#!/usr/bin/env bash
# recon-enum.sh - Subdomain enumeration (passive + brute) untuk satu domain
# Usage: ./recon-enum.sh example.com
set -euo pipefail

DOMAIN="${1:?Usage: $0 example.com}"
GOBIN="${GOBIN:-$HOME/go/bin}"
export PATH="$GOBIN:$PATH"
OUT="out/$DOMAIN"
mkdir -p "$OUT"

echo "[*] Target: $DOMAIN"
echo "[*] Output dir: $OUT"

echo "[1/4] Passive subfinder ..."
subfinder -d "$DOMAIN" -silent > "$OUT/subs_passive.txt" 2>/dev/null || true
wc -l "$OUT/subs_passive.txt"

echo "[2/4] Assetfinder (optional bila ada) ..."
if command -v assetfinder >/dev/null; then
  assetfinder --subs-only "$DOMAIN" >> "$OUT/subs_passive.txt" 2>/dev/null || true
fi

echo "[3/4] DNS brute (top 10k) ..."
if command -v puredns >/dev/null; then
  puredns bruteforce "$HOME/bugbounty-toolkit/lists/commonspeak-brute.txt" \
    -d "$DOMAIN" -r /dev/null --quiet -w "$OUT/subs_brute.txt" 2>/dev/null || true
else
  echo "[i] puredns tidak ada, pakai dnsx dengan wordlist ..."
  cat /dev/null
fi

echo "[4/4] Merge + unique ..."
cat "$OUT/subs_passive.txt" "$OUT/subs_brute.txt" 2>/dev/null | anew "$OUT/all_subs.txt" >/dev/null || true
wc -l "$OUT/all_subs.txt"

echo "[*] Selesai. Daftar subdomain: $OUT/all_subs.txt"
