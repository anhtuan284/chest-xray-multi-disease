from app.rag.index_manager import IndexManager
from app.utils.logging import setup_logging

_index_manager = None

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
