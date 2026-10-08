# 60-rclone.sh
# ================================================================
# Aliases de rclone: montar/desmontar Google Drive como carpetas
# locales. Los 3 remotos son Drive-Muldorgs, Drive-Ragnarok y
# Drive-Novum.
#
# Requisitos previos:
#   - rclone instalado.
#   - Remotos configurados (rclone config).
#   - Directorios destino deben existir:
#       ~/Google-Drive/Drive-Muldorgs
#       ~/Google-Drive/Drive-Ragnarok
#       ~/Google-Drive/Drive-Novum
#   - fuse instalado (para fusermount).
#
# Los mounts se lanzan en segundo plano (&) para no bloquear
# la terminal. El & al final del alias lo hace.
# ================================================================

# --- Montar Google Drive ---
#alias mount-muldorgs='rclone mount Drive-Muldorgs: ~/Google-Drive/Drive-Muldorgs --vfs-cache-mode full &'
#alias mount-ragnarok='rclone mount Drive-Ragnarok:/ ~/Google-Drive/Drive-Ragnarok --vfs-cache-mode full &'
#alias mount-novum='rclone mount Drive-Novum:/ ~/Google-Drive/Drive-Novum --vfs-cache-mode full &'

# --- Desmontar Google Drive ---
#alias umount-muldorgs='fusermount -u ~/Google-Drive/Drive-Muldorgs'
#alias umount-ragnarok='fusermount -u ~/Google-Drive/Drive-Ragnarok'
#alias umount-novum='fusermount -u ~/Google-Drive/Drive-Novum'
