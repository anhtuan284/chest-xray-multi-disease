from fastapi import FastAPI
import uvicorn

from app.api import endpoints
from app.api.dependencies import get_index_manager
from app.core.config import settings
from app.utils.logging import setup_logging


# Configure logging
logger = setup_logging(__name__)

app = FastAPI()
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