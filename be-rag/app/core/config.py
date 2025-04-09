from pydantic_settings import BaseSettings
from pydantic import Field
from typing import Optional
from dotenv import load_dotenv

load_dotenv()  # Load environment variables from .env file


class AppSettings(BaseSettings):
    """Configuration settings for the application."""

    app_name: str = Field("Chest Document Search API", description="This application are response for searching chest documents especially Vietnamese chest documents")
    environment: str = Field("development", description="Environment the application is running in")

    # Server settings
    server_host: str = Field(..., description="Host to run the server on")
    server_port: int = Field(..., description="Port to run the server on")

    # Data directory settings 
    documents_dir: str = Field("data/documents/", description="Path to the documents directory")
    metadata_dir: str = Field("data/metadata/", description="Path to the metadata directory")

    # Logging settings
    log_level: str = Field("INFO", description="Logging level")
    log_file: Optional[str] = Field(None, description="Path to the log file, if any")
    log_stdout: bool = Field(True, description="Whether to log to stdout")

    # Database settings
    vector_database_url: str = Field(..., description="Database connection URL")
    vector_table_name: str = Field(..., description="Name of the table to store vector embeddings in Postgres")

    # Embedding & LLM settings
    embedding_model_name: str = Field(..., description="Name or path of the embedding model")
    embedding_cache_folder: str = Field("./cache", description="Cache directory for embeddings")
    ollama_model_name: str = Field(..., description="Name of the ollama model")
    ollama_server_url: str = Field(..., description="URL of the Ollama server")
    similarity_top_k: int = Field(10, description="The `similarity_top_k` of query engine")

    class Config:
      """Pydantic config."""
      env_file = ".env"

# Create a settings instance
settings = AppSettings()

if __name__ == '__main__':
    # Example usage:
    print(f"App Name: {settings.app_name}")
    print(f"Data Directory: {settings.data_dir}")
    print(f"Documents Directory: {settings.documents_dir}")
    print(f"Embeddings Dir: {settings.embeddings_dir}")
    print(f"Log Level: {settings.log_level}")
    print(f"Database URL: {settings.vector_database_url}")
    print(f"Vector Table Name: {settings.vector_table_name}")
    print(f"Embedding Model Name: {settings.embedding_model_name}")
    print(f"Embedding Cache Folder: {settings.embedding_cache_folder}")
    print(f"Ollama Model Name: {settings.ollama_model_name}")
    print(f"Similarity top K: {settings.similarity_top_k}")