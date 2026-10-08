# 80-scripts.sh
# ================================================================
# Aliases para scripts propios en ~/Scripts_Mios/ y ~/Plantillas/.
#
# ⚠️ Si alguno de estos scripts se mueve o se elimina, el alias
# quedará roto. Verificar con `ls ~/Scripts_Mios/` antes de fiarse.
#
# Duplicados detectados en el .zshrc viejo:
#   temp-hd     = Disk-temp      (ambos llaman a check_temps_smartctl.sh)
#   update-firmware = firm       (ambos llaman a actualizar_firmware.sh)
# Se conservan ambos nombres por compatibilidad con la memoria muscular.
# ================================================================

# --- Temperatura de discos ---
alias temp-hd='$HOME/Scripts_Mios/check_temps_smartctl.sh'
alias Disk-temp='~/Scripts_Mios/check_temps_smartctl.sh'

# --- Actualización ---
alias update='sh ~/Scripts_Mios/Genericos/ragnarok/ragnarok.sh'
alias update-firmware='~/Scripts_Mios/Genericos/Firmware/actualizar_firmware.sh'
alias firm='~/Scripts_Mios/Genericos/Firmware/actualizar_firmware.sh'




