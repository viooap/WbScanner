#!/usr/bin/env bash
# fuzz-content.sh - Content/path discovery dengan ffuf
# Usage: ./fuzz-content.sh https://target.com <wordlist> [dir|vhost|param]
set -euo pipefail

TARGET="${1:?Usage: $0 <url> <wordlist> <mode>}"
WORDLIST="${2:?wordlist required}"
MODE="${3:-dir}"
GOBIN="${GOBIN:-$HOME/go/bin}"
export PATH="$GOBIN:$PATH"
THREADS="${THREADS:-40}"

case "$MODE" in
  dir)
    ffuf -u "$TARGET/FUZZ" -w "$WORDLIST" -t "$THREADS" \
      -mc 200,201,204,301,302,307,401,403,500 -c -o /tmp/ffuf.json 2>/dev/null
    ;;
  vhost)
    ffuf -u "$TARGET" -w "$WORDLIST:Host" -t "$THREADS" \
      -mc 200,301,302,401,403 -H "Host: FUZZ" -c -o /tmp/ffuf_vhost.json 2>/dev/null
    ;;
  param)
    ffuf -u "$TARGET?FUZZ=test" -w "$WORDLIST" -t "$THREADS" \
      -mc 200,302,500 -c -o /tmp/ffuf_param.json 2>/dev/null
    ;;
  *)
    echo "Mode: dir|vhost|param"; exit 1 ;;
esac
