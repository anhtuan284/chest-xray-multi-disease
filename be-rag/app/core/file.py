from pathlib import Path
from fastapi import UploadFile, HTTPException
import magic
from typing import List

from app.api.models import DocumentFile, UploadResponse
from app.core.config import settings
from app.utils.logging import setup_logging

logger = setup_logging(__name__)

class FileService:
    def __init__(self):
        self.root_dir = Path(__file__).parents[2]  # Go up 2 levels to be-rag/
        self.docs_dir = self.root_dir / "data" / "documents"
        logger.info(f"Initializing FileService with documents directory: {self.docs_dir}")
        self._ensure_docs_dir()

    def _ensure_docs_dir(self) -> None:
        """Ensure documents directory exists."""
        if not self.docs_dir.exists():
            self.docs_dir.mkdir(parents=True, exist_ok=True)
            logger.info(f"Created documents directory at {self.docs_dir}")
        else:
            logger.debug(f"Documents directory already exists at {self.docs_dir}")

    def _validate_pdf(self, file: UploadFile) -> None:
        """Validate uploaded file is PDF and within size limit."""
        logger.debug(f"Validating file: {file.filename}")
        
        # Check file size
        file.file.seek(0, 2)  # Seek to end
        size = file.file.tell()
        file.file.seek(0)  # Reset position
        
        if size > settings.max_file_size:
            logger.warning(f"File {file.filename} exceeds size limit: {size} bytes")
            raise HTTPException(
                status_code=413,
                detail=f"File too large. Maximum size is {settings.max_file_size/1024/1024}MB"
            )

        # Check file type
        mime = magic.Magic(mime=True)
        file_type = mime.from_buffer(file.file.read(2048))
        file.file.seek(0)

        if file_type not in settings.allowed_file_types:
            logger.warning(f"Invalid file type for {file.filename}: {file_type}")
            raise HTTPException(
                status_code=415,
                detail=f"File type {file_type} not allowed. Must be PDF."
            )
        logger.debug(f"File {file.filename} passed validation")

    def list_documents(self) -> List[DocumentFile]:
        """Get list of PDF files in documents directory."""
        logger.debug("Scanning documents directory for PDF files")
        files = []
        for file in self.docs_dir.glob("*.pdf"):
            files.append(DocumentFile(
                filename=file.name,
                path=str(file.relative_to(self.root_dir)),
                size=file.stat().st_size,
                created=file.stat().st_ctime
            ))
        logger.info(f"Found {len(files)} PDF documents")
        return files

    def get_document_path(self, filename: str) -> Path:
        """Get document file path and validate it exists."""
        logger.debug(f"Attempting to retrieve document: {filename}")
        file_path = self.docs_dir / filename
        if not file_path.exists() or not filename.endswith(".pdf"):
            logger.warning(f"Document not found or invalid: {filename}")
            raise HTTPException(
                status_code=404,
                detail=f"Document not found: {filename}"
            )
        logger.debug(f"Document found: {filename}")
        return file_path

    def save_document(self, file: UploadFile) -> UploadResponse:
        """Save uploaded document after validation."""
        try:
            logger.info(f"Processing upload request for file: {file.filename}")
            self._validate_pdf(file)
            
            dest = self.docs_dir / file.filename
            logger.debug(f"Saving file to: {dest}")
            
            with dest.open("wb") as buffer:
                buffer.write(file.file.read())
            
            logger.info(f"Successfully saved file: {file.filename}")
            return UploadResponse(
                message="File uploaded successfully",
                path=str(dest.relative_to(self.root_dir))
            )
        except HTTPException as e:
            logger.error(f"HTTP error during file upload: {str(e)}")
            raise e
        except Exception as e:
            logger.error(f"Unexpected error saving document {file.filename}: {str(e)}")
            raise HTTPException(status_code=500, detail=str(e))
