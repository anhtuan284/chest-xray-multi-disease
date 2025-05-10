import os
import multiprocessing
from celery import Celery
from kombu import Exchange, Queue
from celery.signals import worker_process_init, worker_process_shutdown

from dotenv import load_dotenv
load_dotenv()

# # Use spawn instead of fork for worker processes to avoid CUDA context issues
# # This must be set before any other multiprocessing code runs
# multiprocessing.set_start_method('spawn', force=True)

REDIS_URL = os.environ.get('REDIS_URL', 'redis://localhost:6379/0')

# Global Redis connection pool (to be initialized in worker processes)
_redis_connection_pool = None

@worker_process_init.connect
def init_worker_process(*args, **kwargs):
    """
    Initialize resources when a worker process starts
    """
    # Initialize Redis connection pool
    from redis import ConnectionPool
    global _redis_connection_pool
    
    if REDIS_URL.startswith('redis://'):
        # Parse Redis URL to extract necessary components
        from urllib.parse import urlparse
        parsed_url = urlparse(REDIS_URL)
        
        # Extract host and port
        host = parsed_url.hostname or 'localhost'
        port = parsed_url.port or 6379
        
        # Extract password if present
        password = None
        if parsed_url.password:
            password = parsed_url.password
        
        # Extract database number if present
        path = parsed_url.path
        db = int(path.strip('/')) if path else 0
        
        # Create connection pool with limits
        _redis_connection_pool = ConnectionPool(
            host=host,
            port=port,
            password=password,
            db=db,
            max_connections=5,  # Limit concurrent connections
            socket_timeout=5.0,
            socket_connect_timeout=5.0,
            health_check_interval=30
        )
        print(f"Redis connection pool initialized with max_connections=5 for {host}:{port}/{db}")
    else:
        print(f"Warning: Invalid Redis URL format: {REDIS_URL}")

@worker_process_shutdown.connect
def shutdown_worker_process(*args, **kwargs):
    """
    Clean up resources when a worker process shuts down
    """
    global _redis_connection_pool
    if _redis_connection_pool:
        _redis_connection_pool.disconnect()
        print("Redis connection pool has been disconnected")

# Create Celery app
celery_app = Celery(
    'chest_xray_tasks',
    broker=REDIS_URL,
    backend=REDIS_URL,
    include=['tasks']
)

# Configure Celery
celery_app.conf.update(
    # Task settings
    task_serializer='json',
    accept_content=['json'],
    result_serializer='json',
    timezone='UTC',
    enable_utc=True,
    
    # Result settings
    task_ignore_result=False,
    result_expires=1800,  # 30 minutes
    
    # Queue settings
    task_queues=(
        Queue('prediction_tasks', Exchange('prediction_tasks'), routing_key='prediction_tasks'),
        Queue('default', Exchange('default'), routing_key='default'),
    ),
    task_default_queue='default',
    task_default_exchange='default',
    task_default_routing_key='default',
    
    # Performance settings
    worker_prefetch_multiplier=1,  # Don't prefetch more tasks than workers can handle
    worker_concurrency=2,  # Number of worker processes per node
    worker_max_tasks_per_child=50,  # Restart workers after this many tasks (prevent memory leaks)
    
    # Monitoring
    worker_send_task_events=True,
    task_send_sent_event=True,
    
    # Redis connection settings - optimized for Redis Cloud with connection limits
    broker_pool_limit=5,  # Limit the broker connection pool size
    broker_connection_timeout=10.0,  # Connection timeout in seconds
    broker_connection_retry=True,
    broker_connection_retry_on_startup=True,
    broker_connection_max_retries=10,
    broker_heartbeat=30,  # Reduced heartbeat frequency to minimize connections
    
    # Result backend settings
    result_backend_transport_options={
        'socket_timeout': 5.0,
        'socket_connect_timeout': 5.0,
        'visibility_timeout': 3600,  # 1 hour
        'max_connections': 5,  # Limit connections
    },
    
    # Task time limits
    task_soft_time_limit=300,  # 5 minutes
    task_time_limit=600,  # 10 minutes
    
    # Worker settings to fix CUDA issues
    worker_pool='solo',  # Use solo pool instead of prefork for GPU compatibility
)

# Routes for different task types
celery_app.conf.task_routes = {
    'tasks.predict_densenet': {'queue': 'prediction_tasks'},
    'tasks.predict_densenet_cloudinary': {'queue': 'prediction_tasks'},
    'tasks.predict_densenet_minio': {'queue': 'prediction_tasks'},
}

# Helper function to get Redis client with pooling
def get_redis_client():
    """
    Get a Redis client that uses the connection pool
    """
    global _redis_connection_pool
    if _redis_connection_pool is None:
        # This should only happen outside of Celery workers
        # Initialize a standalone Redis client without pooling
        from redis import Redis
        return Redis.from_url(REDIS_URL, socket_timeout=5.0, socket_connect_timeout=5.0)
    else:
        # Use the pool if available (inside worker)
        from redis import Redis
        return Redis(connection_pool=_redis_connection_pool)

# Command to run Celery worker:
# celery -A celery_config worker -Q prediction_tasks --loglevel=info --pool=solo