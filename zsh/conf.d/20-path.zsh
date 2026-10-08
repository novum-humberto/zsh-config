# 20-path.zsh
# ================================================================
# PATH limpio. Solo directorios que existen. Dedupe automático.
# ================================================================

typeset -U path PATH           # dedupe automático: nunca duplicados

# Lista ordenada por prioridad (los primeros tienen preferencia)
local -a new_path=(
    $HOME/.local/bin
    $HOME/.bin
    $HOME/go/bin
    $HOME/.cargo/bin
    $HOME/.lmstudio/bin
    /usr/local/bin
    /usr/local/sbin
    /usr/bin
    /bin
    /usr/sbin
    /sbin
)

# Asignar solo los que existan:
#   ${^new_path}    → expande el array como lista de palabras
#   (N-/)           → N = nullglob, -/ = solo si es directorio
path=(${^new_path}(N-/))
unset new_path

export PATH
