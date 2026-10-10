ARG BASE_VERSION=latest 
FROM sinfallas/base-python-uv:${BASE_VERSION}
LABEL org.opencontainers.image.authors="sinfallas@gmail.com"
LABEL description="Servidor API de Graphifyy optimizado con UV"
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/root/.local/bin:$PATH"

WORKDIR /app

RUN apt update && apt -y dist-upgrade && apt -y install --no-install-recommends --no-install-suggests nano wget curl && apt clean && apt -y autoremove && rm -rf /var/lib/{apt,dpkg,cache,log} && rm -rf /var/cache/* && rm -rf /var/log/apt/* && rm -rf /tmp/*
ARG GRAPHIFYY_VERSION=""
RUN uv tool install "graphifyy[all]${GRAPHIFYY_VERSION}"

EXPOSE 8080
CMD ["graphifyy", "--port", "8080"] 
ARG BUILD_DATE
LABEL org.opencontainers.image.created=$BUILD_DATE
