import textwrap
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import uvicorn

from app.api import endpoints
from app.api.dependencies import get_index_manager
from app.core.config import settings
from app.utils.logging import setup_logging


# Configure logging
logger = setup_logging(__name__)

APP_DESCRIPTION = """
    API for searching and managing chest X-ray related medical documents.
    ### Features
    * Search documents using RAG technology
    * Upload and manage PDF documents
    * Vietnamese language support
    """

app = FastAPI(
    title="Chest X-Ray Document Search API",
    description=textwrap.dedent(APP_DESCRIPTION),
    version="1.0.0",
    openapi_tags=[
        {
            "name": "Search",
            "description": "Search operations using RAG (Retrieval Augmented Generation)",
        },
        {
            "name": "Documents",
            "description": "Operations for managing PDF documents",
        },
    ]
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins in development
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)

app.include_router(endpoints.router)

# Instantiate Index Manager, will be injected by dependencies
get_index_manager()

if __name__ == "__main__":
    logger.info("Starting app...")
    if (settings.environment == "development"):
        logger.info("Running in development mode")
    else:
        logger.info("Running in production mode")

    uvicorn.run(
        "app.main:app", host=settings.server_host, port=settings.server_port,
        log_level=settings.log_level.lower(),
        reload=settings.environment == "development"
    )