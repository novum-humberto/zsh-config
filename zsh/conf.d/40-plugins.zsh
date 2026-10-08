# 40-plugins.zsh
# ================================================================
# Carga de plugins de Zsh.
#
# ORDEN CRÍTICO — no cambiar sin entender las dependencias:
#   1. alias-tips
#   2. history-substring-search
#   3. zsh-autosuggestions
#   4. fzf-tab-git
#   5. fast-syntax-highlighting   ← SIEMPRE AL FINAL
#   6. zsh-sudo
#   7. zsh-timer
#   8. zsh-systemd
#
# Reglas:
#   - syntax highlighting va al final porque intercepta todo.
#   - autosuggestions va antes de fzf-tab.
#   - history-substring-search va antes de autosuggestions.
# ================================================================

# ----------------------------------------------------------------
# 1. alias-tips
# ----------------------------------------------------------------
# Te avisa cuando usas un comando que ya tiene un alias definido.
# Ejemplo: escribes `git status` y te sugiere usar `gst`.
#
# ⚠️ Comentado por defecto: es útil para aprender los aliases, pero
# después de un tiempo se vuelve molesto. Descomenta si lo quieres.
 source /usr/share/zsh/plugins/alias-tips/alias-tips.plugin.zsh

# ----------------------------------------------------------------
# 2. history-substring-search
# ----------------------------------------------------------------
# Permite buscar en el historial con las flechas ↑ ↓ usando el
# texto ya escrito en la línea como filtro.
#
# Ejemplo: escribes `git p` y pulsas ↑ → solo muestra comandos que
# empiezan por `git p`.
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

# Bindings: ↑↓ para buscar, Ctrl+↑↓ para saltar entre resultados.
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# ----------------------------------------------------------------
# 3. zsh-autosuggestions
# ----------------------------------------------------------------
# Muestra una sugerencia gris basada en el historial mientras escribes.
# Aceptas la sugerencia completa con la flecha → (Right arrow).
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Configuración: color de la sugerencia (gris oscuro, discreto).
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# ----------------------------------------------------------------
# 4. fzf-tab-git
# ----------------------------------------------------------------
# Reemplaza el menú de completado de Zsh por un menú interactivo fzf.
# Muy potente: filtra con fuzzy finding en tiempo real.
source /usr/share/zsh/plugins/fzf-tab-git/fzf-tab.plugin.zsh

# --- Configuración de fzf-tab ---

# Desactivar ordenación en `git checkout` (respeta el orden del repo).
zstyle ':completion:*:git-checkout:*' sort false

# Formato de las descripciones (habilita agrupación).
zstyle ':completion:*:descriptions' format '[%d]'

# Colores de los nombres de archivo.
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Desactivar el menú de Zsh (deja que fzf-tab capture el completado).
zstyle ':completion:*' menu no

# Previsualización al completar `ls` (muestra contenido del directorio).
zstyle ':fzf-tab:complete:ls:*' fzf-preview 'ls -la --color=always $realpath'

# Previsualización al completar `cat` (muestra el archivo con bat).
zstyle ':fzf-tab:complete:cat:*' fzf-preview 'bat --color=always $realpath'

# Cambiar de grupo con < y >.
zstyle ':fzf-tab:*' switch-group '<' '>'

# ----------------------------------------------------------------
# 5. zsh-syntax-highlighting
# ----------------------------------------------------------------
# Usamos zsh-syntax-highlighting (no fast-syntax-highlighting) porque:
#   1. Es el que estaba activo en el .zshrc viejo (cargado al final).
#   2. fast-syntax-highlighting tiene un bug con la región de pegado:
#      deja el texto marcado y el cursor invisible tras pegar.
#   3. Soporta ZSH_HIGHLIGHT_STYLES (tema Dracula).
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ----------------------------------------------------------------
# 6. zsh-sudo
# ----------------------------------------------------------------
# Pulsando ESC ESC, prepone `sudo` al comando actual.
# Ejemplo: escribes `pacman -Syu`, pulsas ESC ESC → `sudo pacman -Syu`.
source /usr/share/zsh/plugins/zsh-sudo/sudo.plugin.zsh

# ----------------------------------------------------------------
# 7. zsh-timer
# ----------------------------------------------------------------
# Muestra el tiempo de ejecución de cada comando (si tarda > 1s).
source /usr/share/zsh/plugins/zsh-timer/timer.plugin.zsh

# ----------------------------------------------------------------
# 8. zsh-systemd
# ----------------------------------------------------------------
# Añade completado específico para systemd (unidades, timers, etc.).
source /usr/share/zsh/plugins/zsh-systemd/systemd.plugin.zsh
