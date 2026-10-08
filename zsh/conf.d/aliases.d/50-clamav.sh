# 50-clamav.sh
# ================================================================
# Aliases de ClamAV: escaneo de virus con logs fechados.
#
# Requisitos previos:
#   - Paquete clamav instalado.
#   - Directorio ~/.clamav/ debe existir (los logs se guardan ahí).
#   - La primera vez, ejecutar `sudo freshclam` para bajar la base de firmas.
#
# El log incluye fecha/hora: scan_home_2026-10-04_21-45.log
# ================================================================

# --- Escaneo del home del usuario ---
# Actualiza firmas + escanea $HOME recursivamente + guarda log.
alias scan-home='sudo freshclam && clamscan -r $HOME --log=$HOME/.clamav/scan_home_$(date +%F_%H-%M).log'

# --- Escaneo del sistema completo ---
# Actualiza firmas + escanea / entero con exclusiones de directorios virtuales.
# Excluye /proc, /sys, /dev, /run, /mnt, /media, /tmp (no tienen sentido).
# Limita tamaño de archivo a 500M para no colgarse con archivos enormes.
alias scan-root='sudo freshclam && sudo clamscan -r / --exclude-dir=/proc --exclude-dir=/sys --exclude-dir=/dev --exclude-dir=/run --exclude-dir=/mnt --exclude-dir=/media --exclude-dir=/tmp --max-filesize=500M --max-scansize=500M --log=$HOME/.clamav/scan_root_$(date +%F_%H-%M).log'

# --- Ayuda rápida ---
alias info-clamav='echo -e "\033[1;36m=== CLAMAV ===\033[0m\nscan-home   # Escanea \$HOME + log en ~/.clamav/\nscan-root   # Escanea / + log en ~/.clamav/\nvirus       # Menú interactivo (clamav-virus)"'
