# 42-services.sh
# ================================================================
# Aliases para servicios específicos: VPN, bluetooth, ollama,
# locate, dictd. Cada sección agrupa un servicio.
#
# ⚠️ Nota: en el .zshrc viejo había duplicados:
#    run-ollama  =  ai-on   (ambos hacen start de ollama)
#    stop-ollama =  ai-off  (ambos hacen stop de ollama)
# Se conservan ambos nombres por compatibilidad con la memoria muscular.
# ================================================================

# --- Proton VPN ---
alias vpn-on='sudo systemctl start proton.VPN.service'
alias vpn-off='sudo systemctl stop proton.VPN.service'
alias vpn-status='sudo systemctl status proton.VPN.service'
alias vpn-logs='sudo journalctl -u proton.VPN.service -f'
alias info-vpn='echo -e "\033[1;36m=== PROTON-VPN ===\033[0m\nvpn-on / vpn-off / vpn-status / vpn-logs"'

# --- Bluetooth ---
alias on-bt='sudo systemctl start bluetooth.service'
alias off-bt='sudo systemctl stop bluetooth.service'
alias status-bt='systemctl status bluetooth.service --no-pager -l'
alias bt-logs='journalctl -u bluetooth.service -f'
alias info-bt='echo -e "\033[1;36m=== BLUETOOTH ===\033[0m\non-bt / off-bt / status-bt / bt-logs"'

# --- Ollama (IA local) ---
alias ai-on='sudo systemctl start ollama.service'
alias ai-off='sudo systemctl stop ollama.service'
alias ai-status='systemctl status ollama.service --no-pager -l'
alias ai-logs='journalctl -u ollama.service -f'
# Duplicados históricos (mismos comandos):
#alias run-ollama='sudo systemctl start ollama.service'
#alias stop-ollama='sudo systemctl stop ollama.service'
#alias info-ai='echo -e "\033[1;35m=== IA (OLLAMA) ===\033[0m\nai-on / ai-off / ai-status / ai-logs\nrun-ollama / stop-ollama (alias antiguos, equivalentes)"'

# --- Locate / plocate (búsqueda de archivos) ---
alias locate-on='sudo systemctl start plocate-updatedb.service && echo "OK: base de datos actualizada"'
alias locate-off='sudo systemctl stop plocate-updatedb.service && echo "OK: servicio detenido"'
alias locate-status='systemctl status plocate-updatedb.service --no-pager -l'
alias locate-update='sudo updatedb && echo "OK: base de datos actualizada manualmente"'
alias locate-search='echo "Usar: locate <patron> o plocate <patron>"'
alias info-locate='echo -e "\033[1;32m=== LOCATE / PLOCATE ===\033[0m\nlocate-on / locate-off / locate-status / locate-update / locate-search"'

# --- Dictd (diccionarios offline) ---
alias on-dictd='sudo systemctl start dictd && echo "dictd iniciado"'
alias off-dictd='sudo systemctl stop dictd && echo "dictd detenido"'
alias status-dictd='sudo systemctl status dictd'
