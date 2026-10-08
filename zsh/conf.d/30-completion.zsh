# 30-completion.zsh
# ================================================================
# Sistema de autocompletado (TAB).
#
# Aquí se inicializa compinit (una sola vez) y se configuran los
# zstyles que controlan cómo se comporta el menú de completado.
#
# Orden importante: este archivo debe cargarse DESPUÉS de 20-path.zsh
# (porque compinit busca comandos en el PATH) y ANTES de los plugins
# que usan completado (fzf-tab, etc.).
# ================================================================

# ----------------------------------------------------------------
# 1. COMPINIT con caché inteligente
# ----------------------------------------------------------------
# - Si el caché tiene menos de 24h → cargar rápido con -C
# - Si es viejo o no existe      → regenerar
#
# El caché se llama .zcompdump y vive en $ZDOTDIR.
# ----------------------------------------------------------------

autoload -Uz compinit

local zcompdump="${ZDOTDIR}/.zcompdump"

# El glob (#qN.mh+24) busca archivos modificados hace MÁS de 24h.
# Si encuentra algo, el dump es viejo. Si no existe el archivo, tampoco
# lo encuentra (pero hay que regenerarlo igual).
if [[ -n ${zcompdump}(#qN.mh+24) ]] || [[ ! -f "$zcompdump" ]]; then
    # Dump viejo o inexistente → regenerar
    compinit -d "$zcompdump"
else
    # Dump reciente → cargar rápido (sin chequeo de seguridad)
    compinit -C -d "$zcompdump"
fi

unset zcompdump

# ----------------------------------------------------------------
# 2. ZSTYLES: cómo se comporta el menú de completado
# ----------------------------------------------------------------

# --- Colores de los archivos completados ---
# Usa los mismos colores que `ls` (que vienen de LS_COLORS).
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} 'ma=48;5;197;1'

# --- Formato de las descripciones de grupo ---
# Cuando hay muchos resultados, los agrupa por categoría con este formato.
zstyle ':completion:*:descriptions' format '%F{yellow}[-- %d --]%f'

# --- Formato del aviso "no hay coincidencias" ---
zstyle ':completion:*:warnings' format '%B%F{red}No matches for:%f %F{magenta}%d%b'

# --- Menú de selección ---
# select=2: resalta el primer elemento y permite navegar con flechas.
# verbose: muestra descripción de cada opción.
zstyle ':completion:*' menu select=2
zstyle ':completion:*' verbose true

# --- Cómo se comparan las palabras al completar ---
# Cadena de intentos, de más estricto a más permisivo:
#   ''                    → coincidencia exacta
#   'm:{a-zA-Z}={A-Za-z}' → ignora mayúsculas/minúsculas
#   'r:|[._-]=* r:|=*'    → permite completar después de separadores
#   'l:|=* r:|=*'         → permite completar en medio de la palabra
zstyle ':completion:*' matcher-list \
    '' \
    'm:{a-zA-Z}={A-Za-z}' \
    'r:|[._-]=* r:|=*' \
    'l:|=* r:|=*'

# --- Completar también archivos ocultos ---
# Por defecto, al pulsar TAB no aparecen los archivos que empiezan por .
# Con globdots, sí los incluye.
_comp_options+=(globdots)

# --- Caché de completados (acelera la generación de menús) ---
# Guarda los menús ya generados para no recalcularlos cada vez.
mkdir -p "${ZDOTDIR}/.zcompcache"
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${ZDOTDIR}/.zcompcache"

# --- Colores para el completado de `kill` ---
# Resalta el PID en rojo al matar procesos.
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
