FROM python:3.11-slim

# Install runtime system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN groupadd --system appgroup && useradd --system --no-log-init --gid appgroup appuser

# Set working directory
WORKDIR /app/crawler

# Copy crawler requirements and install dependencies
COPY crawler/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy crawler source and config
COPY crawler/src/ ./src/
COPY crawler/config.yaml ./

# Create data output directory with correct ownership
RUN mkdir -p data && chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Run crawler from the src directory (where crawler.py expects to run)
WORKDIR /app/crawler/src

ENTRYPOINT ["python", "crawler.py"]
