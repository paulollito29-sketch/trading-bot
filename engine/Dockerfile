# Motor del bot (Python). Uso: docker compose up -d   (ver ../docker-compose.yml)
FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    TZ=UTC

# LightGBM necesita OpenMP (libgomp)
RUN apt-get update \
 && apt-get install -y --no-install-recommends libgomp1 \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY pyproject.toml README.md ./
COPY src ./src
RUN pip install .

# Usuario sin privilegios; datos, modelos y reportes en volúmenes.
# El entrypoint arranca como root solo para ajustar el dueño de esas carpetas y luego
# corre el bot como "bot" (en Linux/VPS, Docker las crea como root).
RUN useradd --create-home --uid 1000 bot \
 && mkdir -p /app/data /app/models /app/reports \
 && chown -R bot:bot /app
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN sed -i 's/\r$//' /usr/local/bin/docker-entrypoint.sh \
 && chmod 755 /usr/local/bin/docker-entrypoint.sh

VOLUME ["/app/data", "/app/models", "/app/reports"]
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["cryptobot", "run"]
