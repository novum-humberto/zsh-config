# 00-options.zsh
# ================================================================
# Opciones del shell. Solo setopt/unsetopt. NADA de lógica.
# ================================================================

# --- Comportamiento general ---
setopt AUTOCD                  # cd escribiendo solo el nombre del directorio
setopt INTERACTIVE_COMMENTS    # permite # en la línea interactiva
setopt NO_BEEP                 # sin pitidos
setopt NO_FLOW_CONTROL         # Ctrl+S no congela la terminal
setopt PROMPT_CR               # el prompt usa CR (evita glitches visuales)
setopt PROMPT_SP               # imprime un carácter para no pisar el prompt
setopt MULTIOS                 # tee implícito en redirecciones (cmd > a > b)

# --- Navegación ---
setopt AUTO_PUSHD              # cada cd apila el directorio anterior
setopt PUSHD_IGNORE_DUPS       # no apila el mismo directorio dos veces
setopt PUSHD_SILENT            # no imprime el stack al hacer cd

# --- Completado ---
setopt MENU_COMPLETE           # resalta el primer elemento del menú
setopt LIST_PACKED             # menú de completado más compacto
setopt AUTO_LIST               # lista opciones si hay ambigüedad
setopt COMPLETE_IN_WORD        # completa desde ambos extremos de la palabra

# --- Globbing ---
setopt EXTENDED_GLOB           # globbing avanzado (^, ~, #, etc.)
unsetopt NOMATCH               # no error si un glob no encuentra nada
