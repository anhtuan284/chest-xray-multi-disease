import os
import json
import sys
import psycopg2
import yaml
from llama_index.core import (
    SimpleDirectoryReader
)


from app.core.config import settings
from app.rag.index_manager import IndexManager
from app.utils.logging import setup_logging

logger = setup_logging(__name__)

def sync_documents(force_rebuild=False):
    """
    Syncs documents with the index, either rebuilding completely or updating incrementally.
    """
    required_exts = [".pdf"]
    documents = SimpleDirectoryReader(
        input_dir=settings.documents_dir,   
        required_exts=required_exts,
        recursive=True,   
        filename_as_id=True 
    ).load_data()

    logger.info(f"Found {len(documents)} documents")
    
    if force_rebuild:
        logger.info(f"Force rebuilding index at {settings.vector_table_name}")
        _clear_existing_index()
        
    # Initialize index manager
    index_manager = IndexManager()
    
    if force_rebuild:
        index_manager.build_index(documents)
        logger.info("Index rebuilt successfully")
    else:
        index_manager.sync_index(documents)
        logger.info("Index synced successfully")

def main():
    """
    Parses JSON files, creates LlamaIndex documents,
    and updates the vector index using IndexManager.
    """
    sync_documents(force_rebuild=True)

def _clear_existing_index():
    """
    Clears the existing index in the database. Creates table if it doesn't exist.
    """
    conn = psycopg2.connect(settings.vector_database_url)
    conn.autocommit = True  # Enable autocommit
    cur = conn.cursor()
    try:
        table_name = "data_" + settings.vector_table_name
        
        # Check if table exists
        cur.execute(f"""
            SELECT EXISTS (
                SELECT FROM pg_tables 
                WHERE schemaname = 'public' 
                AND tablename = '{table_name}'
            );
        """)
        exists = cur.fetchone()[0]
        
        if exists:
            logger.info(f"Clearing existing table: {table_name}")
            cur.execute(f"TRUNCATE {table_name};")
        else:
            logger.info(f"Table {table_name} does not exist, skipping clear")
            
    finally:
        cur.close()
        conn.close()


if __name__ == "__main__":
    # Display input to indicate that database will be cleared and re-populated
    # Check if there's input flag of --yes or -y to force the script to run
    if "--y" in sys.argv or "-y" in sys.argv:
        main()
        sys.exit(0)
        
    logger.info("This script will clear the database and re-populate it. Do you want to continue? (y/n)")
    response = input()
    if response.lower() == "y":
        main()
    else:
        logger.info("Exiting. Doing nothing!")

