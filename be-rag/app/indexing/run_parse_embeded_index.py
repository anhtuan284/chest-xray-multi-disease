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

def main():
    """
    Parses JSON files, creates LlamaIndex documents,
    and updates the vector index using IndexManager.
    """

    required_exts = [".pdf"]
    documents = SimpleDirectoryReader(
        input_dir=settings.documents_dir,   
        required_exts=required_exts,
        recursive=True,   
        filename_as_id=True 
    ).load_data()

    logger.info(f"Found {len(documents)} documents")
    logger.info(f"Cleared existing index at {settings.vector_table_name}")
    _clear_existing_index()

    # Initialize index manager
    index_manager = IndexManager()
    index_manager.build_index(documents)
    logger.info("Index Created/Updated successfully")

def _clear_existing_index():
    """
    Clears the existing index in the database.
    """
    conn = psycopg2.connect(settings.vector_database_url)
    cur = conn.cursor()
    table_name = "data_" + settings.vector_table_name
    cur.execute(f"TRUNCATE {table_name};")
    conn.commit()
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

