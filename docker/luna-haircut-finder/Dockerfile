FROM python:3.12-slim

# tzdata so ZoneInfo("Asia/Jerusalem") resolves inside the slim image
RUN apt-get update \
    && apt-get install -y --no-install-recommends tzdata \
    && rm -rf /var/lib/apt/lists/*

ENV PYTHONUNBUFFERED=1

WORKDIR /app

COPY app/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY app/ ./

# Run as a non-root user
RUN useradd --create-home --uid 10001 luna \
    && mkdir -p /data \
    && chown -R luna:luna /app /data
USER luna

CMD ["python", "luna.py"]
