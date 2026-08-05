<img width="877" height="132" alt="image" src="https://github.com/user-attachments/assets/facb4d99-4de2-4aa1-8cfe-d3b9e6005cad" />


# WbScanner
scanner keamanan web untuk menemukan kerentanan pada website/API dan membantu cara memperbaikinya.

# Tujuan 
Wbscanner dibuat untuk menyederhanakan dan mengotomatiskan seluruh proses menemukan kerentanan keamanan pada website/API. Dengan menggabungkan tools terbaik ke dalam satu alur kerja yang teratur, pengguna cukup menjalankan menu interaktif tanpa perlu menghafal perintah rumit, sehingga analisis jadi lebih cepat dan hasilnya tersimpan rapi. Tujuan akhirnya bukan sekadar menemukan celah, tetapi menghasilkan laporan yang jelas beserta rekomendasi cara memperbaikinya — dengan penekanan pada penggunaan yang sah dan bertanggung jawab, hanya untuk target yang sudah diizinkan.

# Support Os

| OS | Cara Menjalankan |
| :--- | :--- |
| **Linux** | `./menu.sh` (+ `install.sh`) |
| **macOS** | `./menu.sh` — sama seperti Linux |
| **Windows** | `menu.bat` — butuh Git Bash untuk menjalankan script `.sh` |

 Go version 1.21 dan git.

# Install
```
git clone https://github.com/viooap/WbScanner.git
```
# Tools 
Tools dalam Wbscanner Toolkit (13 dari install.sh):
- subfinder — enumerasi subdomain pasif
- dnsx — resolve/verifikasi DNS
- naabu — port scanner
- httpx — probe host hidup + deteksi tech
- katana — crawler aktif
- hakrawler — spider
- gau — kumpulkan URL pasif
- waybackurls — URL dari arsip wayback
- unfurl — parse URL/ekstrak path
- ffuf — content/vhost/param fuzzing
- anew — dedupe append
- qsreplace — ganti query parameter
- nuclei — scanner kerentanan berbasis template

Opsional (jika terpasang):

- assetfinder
- puredns

# ⚠️ Peringatan Penting

Wbscanner adalah alat untuk riset keamanan profesional. Penggunaannya hanya diperbolehkan pada target yang sudah diizinkan secara resmi (in-scope pada program bug bounty / kontrak pentest).
Jangan pernah:
- Menguji target yang tidak terdaftar dalam scope / tanpa izin tertulis.
- Menggunakan alat ini untuk tujuan ilegal, merusak, atau mencuri data.
- Melakukan serangan destruktif (menghapus data, drop database, dll).
  

# 📢 Disclaimer
Alat ini disediakan "sebagaimana adanya" (as-is), tanpa jaminan apa pun — baik tersurat maupun tersirat, termasuk garansi kelayakan dagang atau kesesuaian untuk tujuan tertentu.
Dengan menggunakan Wbscanner, Anda menyetujui bahwa:
- Anda sepenuhnya bertanggung jawab atas segala risiko dan konsekuensi penggunaan.
- Pengembang tidak bertanggung jawab atas kerusakan, kehilangan data, kerugian, atau masalah hukum yang timbul dari penggunaan alat ini.
- Anda hanya akan menggunakannya untuk tujuan keamanan & pendidikan yang sah.
💡 Ingat: keamanan yang baik dibangun di atas etika. Gunakan ilmu ini untuk melindungi, bukan merusak.
