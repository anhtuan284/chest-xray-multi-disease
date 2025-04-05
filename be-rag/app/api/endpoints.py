from fastapi import APIRouter, Depends

from app.api.models import (
   SearchRequest,
   SearchResponse,
)
from app.api.dependencies import (
   get_index_manager
)
from app.core.search import SearchService
from app.rag.index_manager import IndexManager

router = APIRouter()

@router.post("/search", response_model=SearchResponse)
async def search_themes(request: SearchRequest, index_manager: IndexManager = Depends(get_index_manager)):
    search_service = SearchService(index_manager)
    response = search_service.search(request)
    return {"answer": response}

