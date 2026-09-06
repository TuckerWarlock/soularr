FROM python:3.14

COPY --from=ghcr.io/astral-sh/uv:0.12.9 /uv /uvx /usr/local/bin/

WORKDIR /app

COPY requirements.txt soularr.py run.sh ./
COPY webui/ webui/
COPY resources/ resources/

RUN apt-get update \
    && apt-get install -y tini \
    && rm -rf /var/lib/apt/lists/* \
    && uv pip install --system --no-cache-dir -r requirements.txt \
    && sed -i 's/\r$//' run.sh \
    && chmod +x run.sh

ENV PYTHONUNBUFFERED=1
ENV IN_DOCKER=Yes

EXPOSE 8265

ENTRYPOINT ["tini", "-g", "--"]
CMD ["/app/run.sh"]
