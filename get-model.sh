#!/usr/bin/env bash
# get-model.sh (v2) — download DistilGPT-2 (quantized ONNX) into ./models/
# Tries huggingface.co first, then the hf-mirror.com mirror for any file
# that fails. Verifies the model file is complete before declaring success.
#
# Run from the repo root:  bash get-model.sh

set -uo pipefail

DEST="models/Xenova/distilgpt2"
SOURCES=(
  "https://huggingface.co/Xenova/distilgpt2/resolve/main"
  "https://hf-mirror.com/Xenova/distilgpt2/resolve/main"
)
FILES=(
  "config.json"
  "tokenizer.json"
  "tokenizer_config.json"
  "generation_config.json"
  "onnx/model_quantized.onnx"
)

mkdir -p "$DEST/onnx"

fetch() {  # fetch <relative-path>
  local f="$1"
  for base in "${SOURCES[@]}"; do
    echo "→ $f  (from ${base%%/Xenova*})"
    if curl -fL --retry 2 --connect-timeout 15 -o "$DEST/$f" "$base/$f"; then
      return 0
    fi
    echo "   ...failed, trying next source"
    rm -f "$DEST/$f"   # never leave partial files behind
  done
  return 1
}

ok=true
for f in "${FILES[@]}"; do
  fetch "$f" || { echo "!! Could not download $f from any source"; ok=false; }
done

# sanity check: the model file must be tens of MB, not a stub or error page
if [ -f "$DEST/onnx/model_quantized.onnx" ]; then
  size=$(wc -c < "$DEST/onnx/model_quantized.onnx")
  if [ "$size" -lt 10000000 ]; then
    echo "!! model_quantized.onnx is only $size bytes — that's a partial/error file, removing it"
    rm -f "$DEST/onnx/model_quantized.onnx"
    ok=false
  else
    echo "✓ model_quantized.onnx looks complete ($(( size / 1024 / 1024 )) MB)"
  fi
fi

echo ""
if $ok; then
  echo "SUCCESS — all files in $DEST"
  du -sh "$DEST"
  echo ""
  echo "Next: commit the models/ folder in GitHub Desktop and push."
else
  echo "FAILED — send the output above to Claude and we'll try another route."
  exit 1
fi