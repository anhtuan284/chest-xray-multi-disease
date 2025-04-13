FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    software-properties-common \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first to leverage Docker cache
COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .


# Expose the port the app runs on
EXPOSE 8033

CMD ["/bin/bash", "-c", "python -m app.indexing.run_parse_embeded_index --y && python -m app.main"]
