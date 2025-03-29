from pydantic import BaseModel, Field

class ImageRequest(BaseModel):
    image: str = Field(..., description="Base64 encoded image string")

class ImageResponse(BaseModel):
    image_urls: str = Field(..., description="Comma-separated string of Cloudinary URLs")
