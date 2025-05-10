import sqlite3
import os
import threading
from datetime import datetime, timedelta
from typing import Dict, List, Optional
import json

class DiseaseStatsService:
    """Service for tracking and retrieving disease prediction statistics using SQLite"""
    
    def __init__(self, data_path: str = None):
        # Default data path logic that works both in Docker and locally
        if data_path is None:
            # Check if /app exists (Docker environment)
            if os.path.exists("/app") and os.access("/app", os.W_OK):
                data_path = "/app/data"
            else:
                # Use local directory for development
                current_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
                data_path = os.path.join(current_dir, "data")
        
        self.data_path = data_path
        self.db_file = os.path.join(data_path, "disease_stats.db")
        self.stats_lock = threading.Lock()
        
        # Create data directory if it doesn't exist
        os.makedirs(data_path, exist_ok=True)
        
        # Initialize database
        self._init_db()
    
    def _get_connection(self):
        """Get a connection to the SQLite database"""
        return sqlite3.connect(self.db_file)
    
    def _init_db(self) -> None:
        """Initialize the SQLite database"""
        with self.stats_lock:
            conn = self._get_connection()
            try:
                cursor = conn.cursor()
                
                # Create disease predictions table
                cursor.execute('''
                    CREATE TABLE IF NOT EXISTS disease_predictions (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        prediction_date DATE NOT NULL,
                        disease_name TEXT NOT NULL,
                        count INTEGER NOT NULL DEFAULT 1
                    )
                ''')
                
                conn.commit()
            except Exception as e:
                print(f"Error initializing database: {e}")
                conn.rollback()
            finally:
                conn.close()
    
    def record_prediction(self, disease_name: str) -> None:
        """
        Record a disease prediction
        
        Args:
            disease_name: The name of the predicted disease
        """
        # Use today's date
        today = datetime.now().strftime('%Y-%m-%d')
        
        with self.stats_lock:
            conn = self._get_connection()
            try:
                cursor = conn.cursor()
                
                # Check if entry exists for today and this disease
                cursor.execute(
                    "SELECT id, count FROM disease_predictions WHERE prediction_date = ? AND disease_name = ?", 
                    (today, disease_name)
                )
                result = cursor.fetchone()
                
                if result:
                    # Update existing entry
                    prediction_id, count = result
                    cursor.execute(
                        "UPDATE disease_predictions SET count = ? WHERE id = ?",
                        (count + 1, prediction_id)
                    )
                else:
                    # Insert new entry
                    cursor.execute(
                        "INSERT INTO disease_predictions (prediction_date, disease_name) VALUES (?, ?)",
                        (today, disease_name)
                    )
                
                conn.commit()
            except Exception as e:
                print(f"Error recording prediction: {e}")
                conn.rollback()
            finally:
                conn.close()
    
    def get_weekly_stats(self) -> Dict[str, Dict[str, int]]:
        """
        Get disease prediction statistics for the current week
        
        Returns:
            Dictionary with days as keys and disease count dictionaries as values
        """
        today = datetime.now()
        # Calculate the start of week (last Monday)
        start_of_week = (today - timedelta(days=today.weekday())).strftime('%Y-%m-%d')
        
        weekly_stats = {}
        
        with self.stats_lock:
            conn = self._get_connection()
            try:
                cursor = conn.cursor()
                
                # Get all predictions for the current week
                cursor.execute(
                    "SELECT prediction_date, disease_name, count FROM disease_predictions WHERE prediction_date >= ?",
                    (start_of_week,)
                )
                
                for date_str, disease, count in cursor.fetchall():
                    if date_str not in weekly_stats:
                        weekly_stats[date_str] = {}
                    
                    weekly_stats[date_str][disease] = count
                
            except Exception as e:
                print(f"Error getting weekly stats: {e}")
            finally:
                conn.close()
        
        return weekly_stats
    
    def get_disease_summary(self) -> Dict[str, int]:
        """
        Get a summary of all disease predictions
        
        Returns:
            Dictionary with disease names as keys and total counts as values
        """
        summary = {}
        
        with self.stats_lock:
            conn = self._get_connection()
            try:
                cursor = conn.cursor()
                
                # Sum counts by disease
                cursor.execute(
                    "SELECT disease_name, SUM(count) FROM disease_predictions GROUP BY disease_name"
                )
                
                for disease, count in cursor.fetchall():
                    summary[disease] = count
                
            except Exception as e:
                print(f"Error getting disease summary: {e}")
            finally:
                conn.close()
        
        return summary
    
    def get_daily_stats(self, days: int = 30) -> Dict[str, Dict[str, int]]:
        """
        Get daily disease prediction statistics for the last specified days
        
        Args:
            days: Number of days to look back
        
        Returns:
            Dictionary with days as keys and disease count dictionaries as values
        """
        today = datetime.now()
        start_date = (today - timedelta(days=days)).strftime('%Y-%m-%d')
        
        daily_stats = {}
        
        with self.stats_lock:
            conn = self._get_connection()
            try:
                cursor = conn.cursor()
                
                # Get all predictions for the specified period
                cursor.execute(
                    "SELECT prediction_date, disease_name, count FROM disease_predictions WHERE prediction_date >= ?",
                    (start_date,)
                )
                
                for date_str, disease, count in cursor.fetchall():
                    if date_str not in daily_stats:
                        daily_stats[date_str] = {}
                    
                    daily_stats[date_str][disease] = count
                
            except Exception as e:
                print(f"Error getting daily stats: {e}")
            finally:
                conn.close()
        
        return daily_stats

# Create a singleton instance
disease_stats_service = DiseaseStatsService()
