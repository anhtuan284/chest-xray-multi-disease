from typing import Dict, List, Optional
from pydantic import BaseModel

class DiseaseStats(BaseModel):
    """Model for disease prediction statistics"""
    weekly_stats: Dict[str, Dict[str, int]]
    total: Dict[str, int]

class DiseaseSummary(BaseModel):
    """Model for disease prediction summary"""
    summary: Dict[str, int]
    total_predictions: int

class StatsResponse(BaseModel):
    """Response model for statistics endpoints"""
    status: str
    data: Dict
