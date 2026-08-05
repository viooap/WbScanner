#!/usr/bin/env bash
# Bug Bounty Toolkit - Web/API - installer (open-source Go tools)
# Wajib punya Go >= 1.21 dan git terinstal.
set -euo pipefail

GOBIN="${GOBIN:-$HOME/go/bin}"
GOBIN="$(realpath "$GOBIN")"

TOOLS=(
  # --- Subdomain & passive recon ---
  github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest   # passive subdomain enum
  github.com/projectdiscovery/dnsx/cmd/dnsx@latest                 # DNS resolver / brute
  # --- HTTP prober & crawler ---
  github.com/projectdiscovery/httpx/cmd/httpx@latest               # probe live hosts / tech
  github.com/projectdiscovery/katana/cmd/katana@latest             # active crawler
  # --- Content / param discovery ---
  github.com/ffuf/ffuf/v2@latest                                   # general fuzzing
  github.com/hakluke/hakrawler@latest                              # spider with wayback
  # --- URL gathering (passive) ---
  github.com/lc/gau/v2/cmd/gau@latest                              # wayback/commoncrawl/otx
  github.com/tomnomnom/waybackurls@latest                          # wayback archived urls
  github.com/tomnomnom/unfurl@latest                               # parse URLs
  # --- Vuln scanning ---
  github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest           # template-based scanner
  # --- Host/port scanning ---
  github.com/projectdiscovery/naabu/v2/cmd/naabu@latest             # fast port scanner
  # --- Utility ---
  github.com/tomnomnom/anew@latest                                 # dedupe append
  github.com/tomnomnom/qsreplace@latest                            # replace query params
)

mkdir -p "$GOBIN"
export GOBIN

echo "[*] GOBIN: $GOBIN"
for t in "${TOOLS[@]}"; do
  name="$(basename "$t" | cut -d@ -f1)"
  if [[ -x "$GOBIN/$name" ]]; then
    echo "[ok] $name sudah ada"
    continue
  fi
  echo "[.] install $name ..."
  go install "$t" || echo "[!] gagal: $t"
done

echo
echo "[*] Selesai. Tools ada di: $GOBIN"
echo "[*] Tambahkan ke PATH bila perlu:"
echo "    export PATH=\"\$PATH:$GOBIN\""
