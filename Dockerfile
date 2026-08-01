FROM sinfallas/base-python-uv:latest
LABEL maintainer="Jesus Palencia sinfallas@gmail.com"

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/root/.local/bin:$PATH"
WORKDIR /app

RUN apt update && apt -y dist-upgrade && apt -y install --no-install-recommends --no-install-suggests nano wget curl && apt clean && apt -y autoremove && rm -rf /var/lib/{apt,dpkg,cache,log} && rm -rf /var/cache/* && rm -rf /var/log/apt/* && rm -rf /tmp/*
RUN uv tool install "graphifyy[all]"

EXPOSE 8080
