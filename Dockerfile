ARG BASE_VERSION=latest
FROM sinfallas/base-python-uv:${BASE_VERSION}

LABEL org.opencontainers.image.authors="Jesus Palencia <sinfallas@gmail.com> (Creado en Tecno Consultores)" \
      org.opencontainers.image.description="Servidor API de Graphify optimizado con UV" \
      org.opencontainers.image.licenses="GPL-2.0-only"

ENV DEBIAN_FRONTEND=noninteractive \
    UV_TOOL_BIN_DIR=/usr/local/bin \
    UV_TOOL_DIR=/opt/uv-tools \
    PATH="/usr/local/bin:$PATH"

WORKDIR /app

RUN apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get -y install --no-install-recommends --no-install-suggests curl ca-certificates && \
    apt-get clean && \
    apt-get -y autoremove && \
    rm -rf /var/lib/{apt,dpkg,cache,log} /var/cache/* /var/log/apt/* /tmp/*

ARG GRAPHIFYY_VERSION=""
ARG GRAPHIFYY_EXTRAS="mcp,neo4j,falkordb,pdf,watch,svg,leiden,office,google,postgres,kimi,ollama,bedrock,anthropic,gemini,openai,chinese,sql,pascal,dm,terraform,ocaml,commonlisp,robot,vbnet,r,erlang,solidity"
RUN mkdir -p /opt/uv-tools && \
    uv tool install --no-cache "graphifyy[${GRAPHIFYY_EXTRAS}]${GRAPHIFYY_VERSION}" && \
    printf '#!/bin/sh\nif [ "${1:-}" = "serve" ]; then\n  shift\n  exec /usr/local/bin/graphify-mcp "$@"\nfi\nexec /usr/local/bin/graphify "$@"\n' > /usr/local/bin/graphifyy && \
    chmod +x /usr/local/bin/graphifyy && \
    chmod -R a+rX /opt/uv-tools

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -s http://127.0.0.1:8080/mcp -m 2 >/dev/null || exit 1

CMD ["graphify-mcp", "/app/graphify-out/graph.json", "--transport", "http", "--host", "0.0.0.0", "--port", "8080"]

ARG BUILD_DATE
LABEL org.opencontainers.image.created=$BUILD_DATE
