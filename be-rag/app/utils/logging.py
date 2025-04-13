import logging
import sys
from logging.handlers import RotatingFileHandler

from app.core.config import settings


class ColorFormatter(logging.Formatter):
    """
    Custom logging formatter that adds colors to log messages based on their level.
    """
    COLORS = {
        "DEBUG": "\033[94m",  # Blue
        "INFO": "\033[92m",   # Green
        "WARNING": "\033[93m", # Yellow
        "ERROR": "\033[91m",   # Red
        "CRITICAL": "\033[95m" # Magenta
    }
    RESET = "\033[0m"

    def format(self, record):
        color = self.COLORS.get(record.levelname, self.RESET)
        message = super().format(record)
        return f"{color}{message}{self.RESET}"


def setup_logging(name, log_level=settings.log_level, log_file=settings.log_file, log_stdout=settings.log_stdout):
    """
    Sets up logging for the application.

    Args:
        name (str): The name of the logger (usually __name__).
        log_level (str): The logging level (e.g., "DEBUG", "INFO", "WARNING", "ERROR").
        log_file (str, optional): Path to the log file. If None, only stream handler will be used.
        log_stdout (bool, optional): Whether to include a StreamHandler for stdout. Defaults to True
    """

    numeric_log_level = getattr(logging, log_level.upper(), None)
    if not isinstance(numeric_log_level, int):
        raise ValueError(f"Invalid log level: {log_level}")

    logger = logging.getLogger(name)
    logger.setLevel(numeric_log_level)

    # Clear existing handlers to prevent duplication
    logger.handlers.clear()
    # Disable propagation to avoid duplicate logs
    logger.propagate = False
    
    formatter = logging.Formatter(
        "%(asctime)s - %(levelname)s - %(name)s - %(filename)s:%(lineno)d - %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S"
    )
    color_formatter = ColorFormatter(
        "%(asctime)s - %(levelname)s - %(name)s - %(filename)s:%(lineno)d - %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S"
    )

    if log_file:
        file_handler = RotatingFileHandler(
            log_file, maxBytes=10 * 1024 * 1024, backupCount=5
        )
        file_handler.setFormatter(formatter)
        logger.addHandler(file_handler)

    if log_stdout:
        log_stdout = logging.StreamHandler(sys.stdout)
        log_stdout.setFormatter(color_formatter)
        logger.addHandler(log_stdout)

    return logger
