#!/usr/bin/env bash
# Wajib punya Go >= 1.21 dan git terinstal.
set -euo pipefail

GOBIN="${GOBIN:-$HOME/go/bin}"
GOBIN="$(realpath "$GOBIN")"

TOOLS=(
  #  Subdomain
  github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest  
  github.com/projectdiscovery/dnsx/cmd/dnsx@latest                 
  #  HTTP prober 
  github.com/projectdiscovery/httpx/cmd/httpx@latest              
  github.com/projectdiscovery/katana/cmd/katana@latest            
  #  Content 
  github.com/ffuf/ffuf/v2@latest                                 
  github.com/hakluke/hakrawler@latest                             
  #  URL gathering (passive) 
  github.com/lc/gau/v2/cmd/gau@latest                            
  github.com/tomnomnom/waybackurls@latest                        
  github.com/tomnomnom/unfurl@latest                               
  #  Vuln scanning 
  github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest           
  #  Host/port scanning 
  github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
  #  Utility 
  github.com/tomnomnom/anew@latest                                 
  github.com/tomnomnom/qsreplace@latest                         
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
