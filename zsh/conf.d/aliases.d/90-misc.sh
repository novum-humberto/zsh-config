# 90-misc.sh
# ================================================================
# Aliases varios que no encajan en otra categoría: consulta de
# hardware, LEDs del teclado, wikis, diccionarios, zellij.
#
# ⚠️ Aliases "raros" comentados: ver notas al pie de cada uno.
# ================================================================

# --- Consultas de hardware ---
# info-nvme: muestra toda la info SMART del NVMe principal.
# Útil para ver salud, temperatura y errores del SSD.
alias info-nvme='sudo smartctl -a /dev/nvme0n1'

# cpu-arqt: detecta qué subdirectorios de glibc-hwcaps soporta tu CPU.
# Sirve para saber si puedes compilar con optimizaciones x86-64-v3/v4.
alias cpu-arqt="sudo /lib64/ld-linux-x86-64.so.2 --help | sed -n '/Subdirectories of glibc-hwcaps/,+10p'"

# system-created: fecha y hora de instalación del sistema actual.
# %w = birth time (fecha de creación del inodo raíz).
alias system-created='echo "Fecha de instalación del sistema:" && stat / -c %w'

# --- LEDs del teclado ---
# led-list: lista todos los LEDs detectados en el sistema.
alias led-list='ls /sys/class/leds/'

# led-info: recordatorio de cómo controlar el LED de Scroll Lock.
# NOTA: originalmente esto solo imprimía un comando de ejemplo. No hacía
# nada. Aquí lo mantengo como "cheat sheet" pero podría eliminarse.
alias led-info='echo "Para encender/apagar LED:"; echo "  echo 1 | sudo tee /sys/class/leds/input12::scrolllock/brightness"; echo "  echo 0 | sudo tee /sys/class/leds/input12::scrolllock/brightness"'

# NOTA: alias "12" (echo 1 | sudo tee /etc/leds/...) NO se migra.
# Dos razones:
#   1. Nombre de un solo carácter numérico: imposible de recordar.
#   2. La ruta /etc/leds/ no existe por defecto en Arch. Es una
#      personalización que probablemente nunca funcionó.
# Si quieres controlar LEDs, usa `led-info` o escribe el comando directo.

# --- Wikis y diccionarios ---
alias wkes='wiki-tui --language es'          # Wikipedia en terminal (español)
alias sdc='sdcv -u "reader.dict ES"'         # diccionario offline español

# --- Zellij ---
# NOTA: el alias original era simplemente "1". Un nombre de un carácter
# es una mala idea (colisiona con números, es difícil de recordar).
# Lo renombro a "zellij-draco" pero dejo "1" por compatibilidad.
#alias zellij-draco='zellij --layout $HOME/.config/zellij/Layouts/Draco.kdl'
#alias 1='zellij --layout $HOME/.config/zellij/Layouts/Draco.kdl'

# NOTA: los siguientes aliases del .zshrc viejo NO se migran:
#
#   alias susp='sudo systemctl suspend -i'
#     → Duplicado: ya tienes `sc-suspend` en 40-systemd.sh
#
#   alias info-all='echo ...' (lista enorme de todos los aliases)
#     → Redundante: ya tienes info-bt, info-ai, info-vpn, info-system,
#       info-clamav, info-locate. Este añadía poco.
#
#   alias generate='gpg --gen-random --armor 1'
#     → Estaba comentado en el .zshrc original. No lo usabas.
#
#   alias curl="curl --user-agent 'noleak'"
#     → Estaba comentado. Además, cambiar el user-agent de curl rompe
#       algunos sitios y APIs. Mejor dejarlo por defecto.
