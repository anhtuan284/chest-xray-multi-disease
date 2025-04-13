from typing import List, Dict, Optional
from pydantic import BaseModel

### Search & Suggest Endpoints

class Preferences(BaseModel):
    recents: Optional[List[str]] = []


class SearchRequest(BaseModel):
    query: str
    tags: Optional[List[str]] = None
    preferences: Preferences


class SearchResponse(BaseModel):
    answer: str

