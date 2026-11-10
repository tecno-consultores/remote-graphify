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
RUN mkdir -p /opt/uv-tools && \
    uv tool install --no-cache "graphifyy[all]${GRAPHIFYY_VERSION}" && \
    if [ -x /usr/local/bin/graphifyy ] && [ ! -e /usr/local/bin/graphify ]; then \
      ln -s /usr/local/bin/graphifyy /usr/local/bin/graphify; \
    elif [ -x /usr/local/bin/graphify ] && [ ! -e /usr/local/bin/graphifyy ]; then \
      ln -s /usr/local/bin/graphify /usr/local/bin/graphifyy; \
    fi && \
    chmod -R a+rX /opt/uv-tools

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -fsS http://127.0.0.1:8080/sse -m 2 >/dev/null || exit 1

CMD ["graphifyy", "--port", "8080"]

ARG BUILD_DATE
LABEL org.opencontainers.image.created=$BUILD_DATE
