#!/usr/bin/env bash
# scan-nuclei.sh - Vulnerability scan dengan nuclei untuk URL list
# Usage: ./scan-nuclei.sh out/example.com/live_urls.txt
set -euo pipefail

INPUT="${1:?Usage: $0 <file_urls>}"
TEMPLATE="${2:-}"
GOBIN="${GOBIN:-$HOME/go/bin}"
export PATH="$GOBIN:$PATH"
OUT="$(dirname "$INPUT")"
mkdir -p "$OUT"

ARGS=(-l "$INPUT" -silent -severity low,medium,high,critical -stats -o "$OUT/nuclei.txt")
[[ -n "$TEMPLATE" ]] && ARGS+=(-t "$TEMPLATE")

echo "[*] Scan nuclei terhadap: $INPUT"
nuclei "${ARGS[@]}" 2>/dev/null || true
echo "[*] Hasil: $OUT/nuclei.txt  (lines: $(wc -l < "$OUT/nuclei.txt" 2>/dev/null || echo 0))"
