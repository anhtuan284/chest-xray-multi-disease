import logging
from typing import Callable, Dict
import psycopg2
from sqlalchemy import make_url

from llama_index.vector_stores.postgres import PGVectorStore
from llama_index.llms.ollama import Ollama
from llama_index.embeddings.huggingface import HuggingFaceEmbedding
from llama_index.core import StorageContext, VectorStoreIndex, Settings, Document
from llama_index.core.vector_stores import MetadataFilters, MetadataFilter, FilterOperator, FilterCondition
from llama_index.core.query_engine import BaseQueryEngine

from app.utils.logging import setup_logging
from app.core.config import settings, AppSettings

logging.basicConfig(level=logging.INFO)  # Set the desired logging level
logger = setup_logging(__name__)

class IndexManager:
    def __init__(self):
        logger.debug("Initializing LLM and Embedding model")
        self.llm = Ollama(model=settings.ollama_model_name, request_timeout=120.0, base_url=settings.ollama_server_url)
        
        self.embed_model = HuggingFaceEmbedding(
          model_name=settings.embedding_model_name, cache_folder=settings.embedding_cache_folder)
        Settings.llm = self.llm
        Settings.embed_model = self.embed_model
        logger.debug("LLM and Embedding model initialized successfully")
        
        logger.debug("Initializing vector store and storage context")
        self.vector_store = _setup_vector_store(settings)
        self.storage_context = _setup_storage_context(settings, self.vector_store)
        logger.debug("Vector store and storage context initialized successfully")
        
        # Client has to call load_index() to load the index
        self.index = None

    def _get_pg_table_name(self):
        return f"data_{settings.vector_table_name}"

    def _is_pg_vector_store_exists(self):
        """Check if if vector store table exists"""
        conn = psycopg2.connect(settings.vector_database_url)
        cur = conn.cursor()
        cur.execute(f"SELECT EXISTS (SELECT 1 FROM pg_tables WHERE schemaname = 'public' AND tablename = '{self._get_pg_table_name()}');")
        exists = cur.fetchone()[0]
        cur.close()
        conn.close()
        return exists

    def load_index(self):     
        """Load or create vector store index."""
        if self._is_pg_vector_store_exists():
            logger.info("Loading index from existing vector store")
            self.index = VectorStoreIndex.from_vector_store(self.vector_store)
            return
        
        logger.info("Vector store table does not exist. Creating empty index...")
        # Create empty index that will create the table
        self.index = VectorStoreIndex.from_documents(
            documents=[],
            storage_context=self.storage_context,
            show_progress=True,
        )
        logger.info("Empty index created successfully")

    def build_index(self, documents: list[Document]):
        """
        Builds the vector index from the given documents.
        """
        try:
            logger.info("Starting vector index building...")
            self.index = VectorStoreIndex.from_documents(
                documents=documents,
                storage_context=self.storage_context,
                show_progress=True,
            )
            # TODO(hails) Refresh changed documents only
            self.index.update_ref_doc

            logger.info("Vector index built successfully.")
        except Exception as e:
            logger.error(f"Error building vector index: {e}")
            raise
        
    def update_nodes_metadata(
        self,
        filter_key: str,
        filter_values: list[str],
        update_callback: Callable[[Dict], Dict],
    ) -> list[str]:
        """
        Updates the metadata of nodes based on a single filter key and allowed values, using a callback function.

        Args:
            filter_key: The metadata key to filter on.
            filter_values: A list of allowed values for the filter key.
            update_callback: A function that exposes a node's metadata dictionary for updating.

        Returns:
            List of matched node IDs (for testing/debugging purposes).
        """
        try:
            nodes = self.vector_store.get_nodes(
                filters=MetadataFilters(filters=[
                    MetadataFilter(key=filter_key, operator=FilterOperator.IN, value=filter_values)
                ])
            )
            if not nodes:
                logger.warning(f"No nodes found for {filter_key} with values {filter_values}.")
                return []

            updated_node_ids = []
            for node in nodes:
                old_metadata = node.metadata.copy()
                new_metadata = update_callback(old_metadata)
                node.metadata.update(new_metadata)
                self.index.update_ref_doc(
                    Document(id_=node.ref_doc_id, text=node.get_content(), metadata=node.metadata)
                )
                updated_node_ids.append(node.ref_doc_id)

            logger.info(f"Updated metadata for {len(updated_node_ids)} nodes: {updated_node_ids}")
            return updated_node_ids

        except Exception as e:
            logger.error(f"Error in update nodes' metadata: {e}")
            raise

    def get_query_engine(self, filter_contains: dict[str, list[str]] = None) -> BaseQueryEngine:
        metadata_filters = _create_filters(filter_contains) if filter_contains else None
        # Create a new query engine if it does not already exist, and add filters if it exist
        return self.index.as_query_engine(
            filters=metadata_filters,
            similarity_top_k=settings.similarity_top_k
        )

    def update_retrieval_params(self):
        # TODO: Implement retrieval parameters update
        pass
        
def _create_filters(contains: dict[str, list[str]] = None) -> MetadataFilters:
    """
    Parse a dictionary of filter values into MetadataFilters

    Args:
        contains (dict[str, list[str]]): A dictionary of key-value pairs where the key is the metadata key and the value is a list of values to filter on.

    Returns:
        MetadataFilters: The parsed filters
    """
    filters = []
    for key, values in contains.items():
        filters.extend([
            MetadataFilter(key=key, operator=FilterOperator.CONTAINS, value=value) for value in values
        ])
    return MetadataFilters(filters=filters)

def _setup_vector_store(settings: AppSettings) -> PGVectorStore:
    """Initialize the vector store."""
    logger.info(f"Initializing PGVectorStore url={settings.vector_database_url}"
                f" table_name={settings.vector_table_name}")
    try:
        # Enable autocommit and create extension if not exists
        conn = psycopg2.connect(settings.vector_database_url)
        conn.autocommit = True
        with conn.cursor() as cur:
            # Create vector extension if not exists
            cur.execute("CREATE EXTENSION IF NOT EXISTS vector;")
        conn.close()
        
    except psycopg2.Error as e:
        logger.error(f"Error connecting to database: {e}")
        raise
    
    url = make_url(settings.vector_database_url)
    out = PGVectorStore.from_params(
      database=url.database,
      host=url.host,
      port=url.port,
      user=url.username,
      password=url.password,
      table_name=settings.vector_table_name,
      embed_dim=384,  # change to our embedding dimension
      hybrid_search=True, # Enable hybrid searchs
      hnsw_kwargs={
          "hnsw_m": 16,
          "hnsw_ef_construction": 64,
          "hnsw_ef_search": 40,
          "hnsw_dist_method": "vector_cosine_ops",
      },          
    )
    logger.info("PGVectorStore initialized successfully")
    return out

def _setup_storage_context(settings: AppSettings, vector_store: PGVectorStore) -> StorageContext:
    """Initialize the storage context."""
    logger.info("Initializing Storage context...")
    try:
      out = StorageContext.from_defaults(
        vector_store=vector_store
      )
      logger.info("Storage context initialized successfully")
      return out
    except Exception as e:
      logger.error(f"Error initializing storage context: {e}")
      raise