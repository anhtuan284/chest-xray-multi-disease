from typing import List, Dict, Optional
from pydantic import BaseModel, Field

class Preferences(BaseModel):
    """User preferences for search customization."""
    
    recents: Optional[List[str]] = Field(
        default=[],
        description="List of recently viewed document IDs"
    )

class SearchRequest(BaseModel):
    """Request model for the search endpoint."""
    
    query: str = Field(
        ...,  # Required field
        description="The search query in Vietnamese or English"
    )
    tags: Optional[List[str]] = Field(
        default=None,
        description="Optional tags to filter documents by categories"
    )
    preferences: Preferences = Field(
        default_factory=Preferences,
        description="User preferences for search customization"
    )

class SearchResponse(BaseModel):
    """Response model for the search endpoint."""
    
    answer: str = Field(
        ...,
        description="Generated response in Vietnamese based on relevant documents"
    )

class DocumentFile(BaseModel):
    """Model representing a PDF document with metadata."""
    
    filename: str = Field(..., description="Name of the PDF file")
    path: str = Field(..., description="Relative path to the file")
    size: int = Field(..., description="File size in bytes")
    created: float = Field(..., description="Creation timestamp (Unix time)")

class UploadResponse(BaseModel):
    """Response model for the file upload endpoint."""
    
    message: str = Field(..., description="Success or error message")
    path: str = Field(..., description="Relative path where file was saved")
