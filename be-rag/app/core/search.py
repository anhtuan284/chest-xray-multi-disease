from app.core.templates import SEARCH_PROMPT_TEMPLATE
from app.rag.index_manager import IndexManager
from app.utils.logging import setup_logging
from app.utils.validators import sanitize_string

logger = setup_logging(__name__)

class SearchService:
    def __init__(self, index_manager: IndexManager):
        self.index_manager = index_manager

    def search(self, request):
        # Validate and sanitize input
        tags = [sanitize_string(val) for val in request.tags] if request.tags else []
        user_query = sanitize_string(request.query)
        
        # Filter for themes that contain the tags
        filter_contains = {
            "tags": tags,
        }
        
        # Construct the prompt
        prompt = SEARCH_PROMPT_TEMPLATE.format(user_query=user_query)
        query_engine = self.index_manager.get_query_engine();
        response = query_engine.query(prompt)

        return response.response

