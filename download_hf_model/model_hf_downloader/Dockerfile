FROM ghcr.io/ggml-org/llama.cpp:full

RUN apt-get update && \
    apt-get install -y python3 python3-venv python3-pip curl && \
    apt-get clean

# Create virtual environment
RUN python3 -m venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

RUN pip install --upgrade pip
RUN pip install huggingface-hub hf-transfer

WORKDIR /app

COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
