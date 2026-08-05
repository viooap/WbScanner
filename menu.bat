@echo off
chcp 65001 >nul
REM ============================================================
REM  MENU.BAT - Bug Bounty Toolkit menu (Windows)
REM  Wajib: Go sudah terinstall + Git Bash tersedia untuk .sh
REM  Cara pakai: klik 2x file ini, lalu pilih angka.
REM ============================================================
setlocal enabledelayedexpansion
title WbScanners - Menu

set "DIR=%~dp0"
set "TOOLS_DIR=%USERPROFILE%\go\bin"

for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do set "ESC=%%b"
set "G=%ESC%[38;5;49m"
set "N=%ESC%[0m"

echo %G%██╗    ██╗██████╗ ███████╗ ██████╗ █████╗ ███╗   ██╗███╗   ██╗███████╗██████╗ ███████╗%N%
echo %G%██║    ██║██╔══██╗██╔════╝██╔════╝██╔══██╗████╗  ██║████╗  ██║██╔════╝██╔══██╗██╔════╝%N%
echo %G%██║ █╗ ██║██████╔╝███████╗██║     ███████║██╔██╗ ██║██╔██╗ ██║█████╗  ██████╔╝███████╗%N%
echo %G%██║███╗██║██╔══██╗╚════██║██║     ██╔══██║██║╚██╗██║██║╚██╗██║██╔══╝  ██╔══██╗╚════██║%N%
echo %G%╚███╔███╔╝██████╔╝███████║╚██████╗██║  ██║██║ ╚████║██║ ╚████║███████╗██║  ██║███████║%N%
echo %G% ╚══╝╚══╝ ╚═════╝ ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝╚══════╝%N%
echo %G%                                     ~ ViZuann          %N%
echo.

:menu
echo.
echo   1) Setup / Install Tools (pertama kali)
echo   2) Cari Subdomain        (Recon)
echo   3) Cek Subdomain Hidup   (Probe)
echo   4) Kumpulkan URL         (Gather)
echo   5) Scan Kerentanan       (Nuclei)
echo   6) Cari Endpoint Tersembunyi (Fuzz)
echo   7) Lihat Hasil Scan
echo   0) Keluar
echo ----------------------------------------
set /p pilih=Pilih nomor: 

if "%pilih%"=="1" goto setup
if "%pilih%"=="2" goto recon
if "%pilih%"=="3" goto probe
if "%pilih%"=="4" goto urls
if "%pilih%"=="5" goto scan
if "%pilih%"=="6" goto fuzz
if "%pilih%"=="7" goto lihat
if "%pilih%"=="0" goto keluar
echo.
echo [X] Angka tidak valid.
goto menu

:setup
echo [!] Cek Go terinstall...
go version >nul 2>&1
if errorlevel 1 (
  echo [X] Go belum terinstall. Download di: https://go.dev/dl/
  echo     Install, lalu klik file ini lagi.
) else (
  echo [>] Menjalankan install.sh (butuh Git Bash)...
  where bash >nul 2>&1 && bash "%DIR%install.sh" || echo [X] Git Bash tidak ada. Install dari: https://git-scm.com/
)
echo.
pause
goto menu

:recon
set /p domain=Masukkan nama domain (contoh: example.com): 
if "%domain%"=="" (
  echo [X] Domain kosong.
  goto menu
)
echo [>] Mencari subdomain untuk %domain% ...
bash "%DIR%scripts\recon-enum.sh" "%domain%"
echo [OK] Beres. Daftar ada di out\%domain%\all_subs.txt
echo.
pause
goto menu

:probe
set /p domain=Domain yang tadi (contoh: example.com): 
if not exist "%DIR%out\%domain%\all_subs.txt" (
  echo [X] Belum ada hasil recon. Jalankan Menu 2 dulu.
  goto menu
)
echo [>] Mengecek subdomain hidup ...
bash "%DIR%scripts\probe-live.sh" "%DIR%out\%domain%\all_subs.txt"
echo [OK] Beres. URL hidup: out\%domain%\live_urls.txt
echo.
pause
goto menu

:urls
set /p domain=Domain (contoh: example.com): 
echo [>] Mengumpulkan URL dari arsip ...
bash "%DIR%scripts\gather-urls.sh" "%domain%"
echo [OK] Beres. URL: out\%domain%\urls_all.txt
echo.
pause
goto menu

:scan
set /p domain=Domain (contoh: example.com): 
if not exist "%DIR%out\%domain%\live_urls.txt" (
  echo [X] Belum ada URL hidup. Jalankan Menu 3 dulu.
  goto menu
)
echo [>] Scan kerentanan (bisa lama) ...
bash "%DIR%scripts\scan-nuclei.sh" "%DIR%out\%domain%\live_urls.txt"
echo [OK] Beres. Hasil: out\%domain%\nuclei.txt
echo.
pause
goto menu

:fuzz
set /p url=URL target (contoh: https://example.com): 
echo [>] Mencari endpoint tersembunyi ...
bash "%DIR%scripts\fuzz-content.sh" "%url%" "%DIR%lists\med.txt" dir
echo [OK] Beres. Hasil fuzz: /tmp/ffuf.json
echo.
pause
goto menu

:lihat
set /p domain=Domain (contoh: example.com): 
if not exist "%DIR%out\%domain%" (
  echo [X] Folder out\%domain% tidak ada.
  goto menu
)
echo [>] Isi folder out\%domain% :
dir /b "%DIR%out\%domain%"
set /p f=File yang mau dibaca (contoh: live_urls.txt): 
if exist "%DIR%out\%domain%\%f%" (
  echo ----------------------------------------
  type "%DIR%out\%domain%\%f%"
  echo ----------------------------------------
) else (
  echo [X] File tidak ada.
)
echo.
pause
goto menu

:keluar
echo Sampai jumpa!
endlocal
exit
