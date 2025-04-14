from pathlib import Path
from fastapi import APIRouter, UploadFile, File
from fastapi.params import Depends
from fastapi.responses import FileResponse
from typing import List

from app.rag.index_manager import IndexManager
from app.api.models import (
   SearchRequest, SearchResponse,
   DocumentFile, UploadResponse
   
)
from app.api.dependencies import (
   get_index_manager,
   get_file_service
)
from app.core.search import SearchService
from app.core.file import FileService

router = APIRouter()

PROJECT_ROOT = Path(__file__).parents[2]  # Go up 2 levels to be-rag/

@router.post("/search", 
    response_model=SearchResponse,
    tags=["Search"],
    summary="Search documents",
    description="Search chest documents using RAG (Retrieval Augmented Generation) and get responses in Vietnamese"
)
async def search_themes(request: SearchRequest, index_manager: IndexManager = Depends(get_index_manager)):
    """
    Search chest documents using RAG.

    - Uses Vietnamese language model for responses
    - Filters by optional tags
    - Considers user preferences
    """
    search_service = SearchService(index_manager)
    response = search_service.search(request)
    return {"answer": response}

@router.get("/documents", 
    response_model=List[DocumentFile],
    tags=["Documents"],
    summary="List all documents",
    description="List all PDF documents in the documents directory with their metadata"
)
async def list_documents(file_service: FileService = Depends(get_file_service)):
    """List all PDF documents in the documents directory."""
    return file_service.list_documents()

@router.get("/documents/{filename}/view",
    tags=["Documents"],
    summary="View document",
    description="View a PDF document directly in the browser"
)
async def view_document(
    filename: str,
    file_service: FileService = Depends(get_file_service)
):
    """View a PDF document in the browser."""
    file_path = file_service.get_document_path(filename)
    return FileResponse(
        str(file_path),
        media_type="application/pdf",
        filename=filename,
        content_disposition_type="inline"
    )

@router.get("/documents/{filename}",
    tags=["Documents"],
    summary="Download document",
    description="Download a PDF document (triggers browser download)"
)
async def get_document(
    filename: str,
    file_service: FileService = Depends(get_file_service)
):
    """Download a PDF document."""
    file_path = file_service.get_document_path(filename)
    return FileResponse(
        str(file_path),
        media_type="application/pdf",
        filename=filename,
        content_disposition_type="attachment"
    )

@router.post("/documents/upload",
    response_model=UploadResponse,
    tags=["Documents"],
    summary="Upload document",
    description="Upload a new PDF document (max 10MB)"
)
async def upload_document(
    file: UploadFile = File(...),
    file_service: FileService = Depends(get_file_service)
):
    """Upload a PDF document."""
    return file_service.save_document(file)

