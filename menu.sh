#!/usr/bin/env bash
# menu.sh - Menu interaktif Bug Bounty Toolkit (Linux/macOS/Git Bash)
# Tinggal pilih angka, script yang kerjain.
set -uo pipefail

# warna
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
# banner: hijau terang + sentuhan cyan (#1FFFAA / #00FF99)
BAN='\033[38;2;31;255;170m'

# banner
banner() {
  echo -e "${BAN}██╗    ██╗██████╗ ███████╗ ██████╗ █████╗ ███╗   ██╗███╗   ██╗███████╗██████╗ ███████╗${NC}"
  echo -e "${BAN}██║    ██║██╔══██╗██╔════╝██╔════╝██╔══██╗████╗  ██║████╗  ██║██╔════╝██╔══██╗██╔════╝${NC}"
  echo -e "${BAN}██║ █╗ ██║██████╔╝███████╗██║     ███████║██╔██╗ ██║██╔██╗ ██║█████╗  ██████╔╝███████╗${NC}"
  echo -e "${BAN}██║███╗██║██╔══██╗╚════██║██║     ██╔══██║██║╚██╗██║██║╚██╗██║██╔══╝  ██╔══██╗╚════██║${NC}"
  echo -e "${BAN}╚███╔███╔╝██████╔╝███████║╚██████╗██║  ██║██║ ╚████║██║ ╚████║███████╗██║  ██║███████║${NC}"
  echo -e "${BAN} ╚══╝╚══╝ ╚═════╝ ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝╚══════╝${NC}"
  echo -e "${BAN}                                     ~ ViZuann          ${NC}"
  echo
}

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export GOBIN="${GOBIN:-$HOME/go/bin}"
export PATH="$GOBIN:$PATH"

# warna
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'

# fungsi tanya jawab 
ask() { # $1 = pesan, $2 = var name (default)
  local var="$2"; local def="${3:-}"
  read -rp "$1" "${var}"
  if [[ -z "${!var}" ]]; then printf -v "$var" "%s" "$def"; fi
}

ok()   { echo -e "${GREEN}[OK]${NC} $1"; }
info() { echo -e "${CYAN}[>]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[X]${NC} $1"; }

check_go() {
  if ! command -v go >/dev/null 2>&1; then
    err "Go belum terinstal. Install dulu: https://go.dev/dl/"
    return 1
  fi
  return 0
}

cek_tool() { command -v "$1" >/dev/null 2>&1; }

setup_path() {
  info "Daftar tools yang belum ada akan di-install otomatis (butuh internet)."
  if [[ -f "$DIR/install.sh" ]]; then bash "$DIR/install.sh"; ok "Instalasi selesai."; fi
  warn "Kalau tools belum dikenali, restart terminal lalu jalankan lagi:"
  echo "    export PATH=\"\$HOME/go/bin:\$PATH\""
}

#  MENU 1 : RECON
menu_recon() {
  local domain; ask "Masukkan nama domain (contoh: example.com): " domain
  [[ -z "$domain" ]] && { err "Domain kosong."; return; }
  info "Mencari subdomain untuk: $domain"
  bash "$DIR/scripts/recon-enum.sh" "$domain"
  ok "Selesai. Daftar subdomain ada di: $DIR/out/$domain/all_subs.txt"
}

# MENU 2 : PROBE 
menu_probe() {
  local domain; ask "Domain yang tadi (contoh: example.com): " domain
  local file="$DIR/out/$domain/all_subs.txt"
  [[ -f "$file" ]] || { err "File $file tidak ditemukan. Jalankan Menu 1 dulu."; return; }
  info "Mengecek subdomain hidup ..."
  bash "$DIR/scripts/probe-live.sh" "$file"
  ok "Selesai. URL hidup: $DIR/out/$domain/live_urls.txt"
}

#  MENU 3 : URL 
menu_urls() {
  local domain; ask "Domain (contoh: example.com): " domain
  info "Mengumpulkan URL dari arsip ..."
  bash "$DIR/scripts/gather-urls.sh" "$domain"
  ok "Selesai. URL: $DIR/out/$domain/urls_all.txt"
}

#  MENU 4 : SCAN 
menu_scan() {
  local domain; ask "Domain (contoh: example.com): " domain
  local file="$DIR/out/$domain/live_urls.txt"
  [[ -f "$file" ]] || { err "File $file tidak ditemukan. Jalankan Menu 2 dulu."; return; }
  info "Scan kerentanan (bisa lama) ..."
  bash "$DIR/scripts/scan-nuclei.sh" "$file"
  ok "Selesai. Hasil: $DIR/out/$domain/nuclei.txt"
}

#  MENU 5 : FUZZ 
menu_fuzz() {
  local url wordlist; ask "URL target (contoh: https://example.com): " url
  wordlist="$DIR/lists/med.txt"
  info "Mencari halaman/endpoint tersembunyi ..."
  bash "$DIR/scripts/fuzz-content.sh" "$url" "$wordlist" dir
  ok "Selesai. Hasil fuzz: /tmp/ffuf.json"
}

#  MENU 6 : BACA HASIL 
menu_lihat() {
  local domain; ask "Domain (contoh: example.com): " domain
  local d="$DIR/out/$domain"
  [[ -d "$d" ]] || { err "Folder $d tidak ada."; return; }
  ls -1 "$d"
  local f; ask "File yang mau dibaca (contoh: live_urls.txt): " f
  [[ -f "$d/$f" ]] && { echo "---- $d/$f ----"; cat "$d/$f"; } || err "File tidak ada."
}

#  MENU UTAMA 
while true; do
  banner
  echo -e "${BAN}----------------------------------------${NC}"
  echo "  1) Setup / Install Tools (pertama kali)"
  echo "  2) Cari Subdomain        (Recon)"
  echo "  3) Cek Subdomain Hidup   (Probe)"
  echo "  4) Kumpulkan URL         (Gather)"
  echo "  5) Scan Kerentanan       (Nuclei)"
  echo "  6) Cari Endpoint Tersembunyi (Fuzz)"
  echo "  7) Lihat Hasil Scan"
  echo "  0) Keluar"
  echo "----------------------------------------"
  read -rp "Pilih nomor: " pilih
  case "${pilih:-}" in
    1) [ "$(check_go)" ] && setup_path ;;
    2) menu_recon ;;
    3) menu_probe ;;
    4) menu_urls ;;
    5) menu_scan ;;
    6) menu_fuzz ;;
    7) menu_lihat ;;
    0) echo "Sampai jumpa!"; exit 0 ;;
    *) err "Angka tidak valid." ;;
  esac
done
