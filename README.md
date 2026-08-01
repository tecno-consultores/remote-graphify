# Remote Graphify Server

A containerized implementation of [Graphify](https://github.com/Graphify-Labs/graphify) exposing a Model Context Protocol (MCP) server over HTTP/SSE. This image is designed to be easily consumed by autonomous agents (like Hermes) via Docker Compose.

## Features
* **MCP Ready**: Exposes Graphify's API over HTTP (SSE) for seamless agent integration.
* **Multi-LLM Support**: Pre-configured environment variables for Ollama, Anthropic, Gemini, and OpenAI.
* **IPv6 Enabled**: Configured for modern networking architectures with IPv6 support.
* **Pre-installed Dependencies**: Built with `uv` and includes `graphifyy[all]` for maximum compatibility out-of-the-box.

## Quick Start

### 1. Extract your Graph
The MCP server reads from a static graph file. Before starting the server, you must generate the `graph.json` file from your project code. Run this locally or via an ephemeral container inside your project directory:
```bash
uvx graphifyy extract
```
This will create a `graphify-out/` directory containing the required data.

### 2. Start the Server
Use the provided `docker-compose.yml` to bring up the service:
```bash
docker compose up -d
```

### 3. Connect your Agent
Configure your agent (e.g., Hermes) to connect to the remote MCP server using the SSE transport. If both containers share the same Docker network, use the internal hostname:
* **Endpoint URL**: `http://graphify:8080/sse` 

## Configuration Options
Modify the `environment` section in your `docker-compose.yml` to configure your preferred LLM provider.

### Local Models (Ollama)
If you are running Ollama on your Docker host machine, be sure to use `host.docker.internal` or your host's local IP address instead of `localhost`:
```yaml
OLLAMA_BASE_URL=[http://host.docker.internal:11434](http://host.docker.internal:11434)
GRAPHIFY_OLLAMA_KEEP_ALIVE=10
```

### Cloud Models
Uncomment and populate the relevant variables for cloud providers:
* `ANTHROPIC_API_KEY` / `ANTHROPIC_MODEL`
* `GEMINI_API_KEY`
* `OPENAI_API_KEY` / `OPENAI_BASE_URL` / `OPENAI_MODEL`

---
**Docker Hub**: [sinfallas/remote-graphify](https://hub.docker.com/r/sinfallas/remote-graphify)

