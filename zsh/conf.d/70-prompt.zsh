# 70-prompt.zsh
# ================================================================
# Prompt dinámico - réplica EXACTA del prompt viejo.
#
# Contextos:
#   - Raíz "/"               → rojo/amarillo/verde
#   - $HOME                  → celeste
#   - Subdir de $HOME        → azul/magenta/cyan
#   - Fuera de $HOME         → magenta/verde/amarillo
#
# IMPORTANTE: se fuerza PROMPT_SUBST aquí aunque 00-options.zsh
# ya lo active. Así no dependemos del orden de carga ni de fallos
# en otros archivos.
# ================================================================

# Forzar PROMPT_SUBST (evaluar $(comandos) en $PROMPT)
setopt PROMPT_SUBST

# ----------------------------------------------------------------
# vcs_info: info de Git
# ----------------------------------------------------------------
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats ' [%F{yellow}⎇%f %b]'
zstyle ':vcs_info:git*' actionformats ' [%F{yellow}⎇%f %b|%a]'

# ----------------------------------------------------------------
# Icono según nombre del directorio
# ----------------------------------------------------------------
# ⚠️ Los emojis de esta función pueden diferir de los originales
# por la corrupción del .zshrc. Si quieres los EXACTOS, copia la
# función completa desde tu ~/.zshrc activo (el del panel izquierdo).
function get_dir_icon {
    local dir_name=${PWD##*/}
    case "$dir_name" in
        Vídeos|vídeos)
            echo "%B%F{#FFA500}%%f%b"           # video (naranja)
            ;;
        Descargas|downloads)
            echo "%B%F{#87CEEB}󰅢%f%b"            # descarga (azul claro)
            ;;
        Imágenes|images|Pictures)
            echo "%B%F{#FF69B4}%f%b"           # imagen (rosa)
            ;;
        Documentos|documents|Documents)
            echo "%B%F{#FFFF00}%f%b"           # documento (amarillo)
            ;;
        Música|music|Music)
            echo "%B%F{#FF4500}🎵%f%b"           # música (naranja oscuro)
            ;;
        *)
            if [[ "$PWD" == "$HOME" ]]; then
                echo "%B%F{#FFA500}%f%b"       # casa (naranja)
            else
                echo "%B%F{#87CEEB}%f%b"       # carpeta (azul claro)
            fi
            ;;
    esac
}

# ----------------------------------------------------------------
# Prompt dinámico (idéntico al viejo)
# ----------------------------------------------------------------
function dynamic_prompt {
    if [[ "$PWD" == "/" ]]; then
        # Contexto: raíz del sistema
        echo "%B%F{red}┌──[%f%b %F{yellow}$USER%f%b %F{green}]──(%f%b %F{blue}%f%b %F{magenta}/%f%b %F{cyan})%f%b"
        echo "%B%F{red}└─➤%f%b "
    elif [[ "$PWD" == "$HOME" ]]; then
        # Contexto: $HOME
        echo "%B%F{#87CEEB}┌──[%f%b %F{#87CEEB}$USER%f%b %F{#87CEEB}]──(%f%b $(get_dir_icon) %F{#FF69B4} %F{#87CEEB})%f%b"
        echo "%B%F{#87CEEB}└─➤%f%b "
    elif [[ "$PWD" == "$HOME"/* ]]; then
        # Contexto: subdirectorios de $HOME
        echo "%B%F{blue}┌──[%f%b %F{magenta}$USER%f%b %F{cyan}]──(%f%b $(get_dir_icon) %F{green}%1/%f%b %F{red})%f%b"
        echo "%B%F{blue}└─➤%f%b "
    else
        # Contexto: fuera de $HOME
        echo "%B%F{magenta}┌──[%f%b %F{green}$USER%f%b %F{yellow}]──(%f%b $(get_dir_icon) %F{red}%1/%f%b %F{blue})%f%b"
        echo "%B%F{magenta}└─➤%f%b "
    fi
}

# ----------------------------------------------------------------
# PROMPT final
# ----------------------------------------------------------------
PROMPT='$(dynamic_prompt)${vcs_info_msg_0_}'
