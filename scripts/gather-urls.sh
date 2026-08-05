#!/usr/bin/env bash
# gather-urls.sh - Kumpulkan URL dari sumber pasif (wayback, gau, commoncrawl, etc)
# Usage: ./gather-urls.sh example.com
set -euo pipefail

DOMAIN="${1:?Usage: $0 example.com}"
GOBIN="${GOBIN:-$HOME/go/bin}"
export PATH="$GOBIN:$PATH"
OUT="out/$DOMAIN"
mkdir -p "$OUT"

echo "[*] gau (wayback + commoncrawl + otx) ..."
gau --threads 5 "$DOMAIN" 2>/dev/null | anew "$OUT/urls_all.txt" || true

echo "[*] waybackurls ..."
echo "$DOMAIN" | waybackurls 2>/dev/null | anew "$OUT/urls_all.txt" || true

echo "[*] Total unique URLs: $(wc -l < "$OUT/urls_all.txt")"

echo "[*] Filter URI path (untuk discovery) ..."
unfurl paths < "$OUT/urls_all.txt" 2>/dev/null | sort -u > "$OUT/paths.txt"
wc -l "$OUT/paths.txt"
echo "Output: $OUT/urls_all.txt dan $OUT/paths.txt"
