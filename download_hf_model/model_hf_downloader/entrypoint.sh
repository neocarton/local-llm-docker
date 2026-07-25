#!/bin/bash

set -e

# Check if model name is provided
if [ -z "$MODEL_NAME" ]; then
    echo "MODEL_NAME enviroment variable is not set"
    exit 1
fi

# Setup
MODEL_BASE_NAME="${MODEL_NAME##*/}"
OUTPUT_DIR="/app/models/$MODEL_NAME"
GGUF_OUTPUT="$OUTPUT_DIR/$MODEL_BASE_NAME.gguf"
#QUANTIZED_GGUF_OUTPUT="$OUTPUT_DIR/$MODEL_NAME-Q4_K_M.gguf"

mkdir -p "$OUTPUT_DIR"

# Download model using Hugging Face CLI
echo "Downloading model $MODEL_NAME..."
export HF_HUB_ENABLE_HF_TRANSFER=0
export HF_HUB_DOWNLOAD_THREADS=2
hf download --local-dir "$OUTPUT_DIR" "$MODEL_NAME" $MODEL_FILE

# Convert to GGUF using llama.cpp's convert script
if [ "$CONVERT_TO_GGUF" = "true" ]; then
    echo "Converting to GGUF format..."
    python3 /app/convert_hf_to_gguf.py --outfile "$GGUF_OUTPUT" --model-name "$MODEL_NAME" "$OUTPUT_DIR"
    echo "GGUF model saved to $GGUF_OUTPUT"
fi

#echo "Quantizing to 4-bit (Q4_K_M)..."
#./llama-quantize "$GGUF_OUTPUT" "$QUANTIZED_GGUF_OUTPUT" Q4_K_M
#echo "Quantizing GGUF model saved to $QUANTIZED_GGUF_OUTPUT"
