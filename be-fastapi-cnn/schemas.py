from pydantic import BaseModel, Field
from typing import Optional, Any, Dict, List

class ImageRequest(BaseModel):
    image: str = Field(..., description="Base64 encoded image string")

class ImageResponse(BaseModel):
    image_urls: str = Field(..., description="Comma-separated string of Cloudinary URLs")

# New response schema for MinIO storage
class MinioImageResponse(BaseModel):
    image_urls: List[str] = Field(..., description="List of MinIO presigned URLs for the images")
    status: str = Field("success", description="Status of the operation")

# Task-related schemas
class TaskRequest(BaseModel):
    """Base model for task request"""
    task_id: Optional[str] = Field(None, description="ID of an existing task to check")

class TaskSubmitResponse(BaseModel):
    """Response model for task submission"""
    task_id: str = Field(..., description="ID of the submitted task")
    status: str = Field(..., description="Status of the task")

class TaskStatusResponse(BaseModel):
    """Response model for task status check"""
    task_id: str = Field(..., description="ID of the task")
    status: str = Field(..., description="Current status of the task")
    result: Optional[Dict[str, Any]] = Field(None, description="Task result if completed")
    error: Optional[str] = Field(None, description="Error message if task failed")

class TaskListResponse(BaseModel):
    """Response model for listing tasks"""
    tasks: List[Dict[str, Any]] = Field(..., description="List of tasks with their statuses")
    count: int = Field(..., description="Total number of tasks")
