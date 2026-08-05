#!/usr/bin/env bash
# probe-live.sh - Probe host/domain mana yang hidup (live) + deteksi tech
# Usage: ./probe-live.sh out/example.com/all_subs.txt
set -euo pipefail

INPUT="${1:?Usage: $0 <file_subs>}"
GOBIN="${GOBIN:-$HOME/go/bin}"
export PATH="$GOBIN:$PATH"
OUT="$(dirname "$INPUT")"
mkdir -p "$OUT"

echo "[*] Resolve + probe live (httpx) ..."
httpx -l "$INPUT" \
  -silent \
  -status-code -title -tech-detect \
  -follow-redirects \
  -json -o "$OUT/httpx.json" 2>/dev/null

echo "[*] Daftar URL hidup (plain) ..."
httpx -l "$INPUT" -silent -no-color -follow-redirects 2>/dev/null | anew "$OUT/live_urls.txt"
wc -l "$OUT/live_urls.txt"
echo "Detail JSON: $OUT/httpx.json"
