FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
COPY export_back4apps_data.py .
COPY import_to_parse_server.py .
RUN pip install --no-cache-dir -r requirements.txt

CMD ["bash", "-c", "\
    python export_back4apps_data.py || { echo '❌ Export failed'; exit 1; }; \
    python import_to_parse_server.py  && \
    echo '✅ Migration completed successfully! 🎉'"]
