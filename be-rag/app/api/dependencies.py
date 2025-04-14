from app.rag.index_manager import IndexManager
from app.core.file import FileService
from app.utils.logging import setup_logging

_index_manager = None
_file_service = None

logger = setup_logging(__name__)

def get_index_manager() -> IndexManager:
    global _index_manager
    
    if _index_manager is None:
      logger.info("Creating IndexManager")
      _index_manager = IndexManager()
      _index_manager.load_index()
      logger.info("IndexManager created")
    else:
      logger.info("IndexManager already exists. Returning existing instance")

    return _index_manager

def get_file_service() -> FileService:
    global _file_service
    if _file_service is None:
        _file_service = FileService()
    return _file_service
