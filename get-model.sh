#!/usr/bin/env bash
# get-model.sh — one-time download of DistilGPT-2 (quantized ONNX) into ./models/
# so Glassbox serves the model itself with no runtime Hugging Face dependency.
#
# Run this from the repo root on a network that can reach huggingface.co:
#   bash get-model.sh
# Then commit and push the models/ folder.

set -euo pipefail

BASE="https://huggingface.co/Xenova/distilgpt2/resolve/main"
DEST="models/Xenova/distilgpt2"

FILES=(
  "config.json"
  "tokenizer.json"
  "tokenizer_config.json"
  "generation_config.json"
  "onnx/model_quantized.onnx"
)

mkdir -p "$DEST/onnx"

for f in "${FILES[@]}"; do
  echo "→ downloading $f"
  curl -fL --retry 3 --create-dirs -o "$DEST/$f" "$BASE/$f"
done

echo ""
echo "All files downloaded into $DEST"
du -sh "$DEST"
echo ""
echo "Next steps:"
echo "  1. In GitHub Desktop you'll see the new models/ folder as changes"
echo "  2. Commit with a message like 'Self-host model files' and push"
echo "  3. Wait ~1 minute for Pages to redeploy, then reload the site"
