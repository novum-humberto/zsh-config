# 50-keybindings.zsh
# ================================================================
# Atajos de teclado (keybindings) para Zsh.
#
# FILOSOFÍA (heredada del .zshrc viejo, que funcionaba en cualquier
# terminal, DE, WM y distro):
#
#   1. NO sobreescribir defaults buenos de Zsh. Ej: `^?` ya borra
#      carácter por defecto. No lo tocamos.
#   2. Solo definir lo que Zsh no trae. Ej: `^H` → borrar palabra.
#   3. Usar terminfo cuando es portable entre terminales.
#   4. Acumular secuencias cuando hay varias variantes conocidas.
#   5. NO inventar secuencias "por si acaso". Solo las verificadas.
#
# Este archivo es una migración FIEL del bloque de bindkeys del
# ~/.zshrc viejo, solo reorganizado y comentado.
# ================================================================

# ----------------------------------------------------------------
# Modo de edición de línea
# ----------------------------------------------------------------
bindkey -e

# ----------------------------------------------------------------
# HOME y END
# ----------------------------------------------------------------
# Acumulamos varias secuencias conocidas + terminfo.
# Todas funcionan a la vez (bindkey no sobreescribe, acumula).

bindkey '^[[7~' beginning-of-line                    # Home (rxvt, algunos VTE)
bindkey '^[[H'  beginning-of-line                    # Home (xterm, foot, kitty, alacritty)

# Detección por terminfo (portable entre terminales)
if [[ -n "${terminfo[khome]}" ]]; then
    bindkey "${terminfo[khome]}" beginning-of-line
fi

bindkey '^[[8~' end-of-line                          # End (rxvt, algunos VTE)
bindkey '^[[F'  end-of-line                          # End (xterm, foot, kitty, alacritty)

if [[ -n "${terminfo[kend]}" ]]; then
    bindkey "${terminfo[kend]}" end-of-line
fi

# ----------------------------------------------------------------
# TECLAS ESPECIALES
# ----------------------------------------------------------------
bindkey '^[[2~' overwrite-mode                       # Insert
bindkey '^[[3~' delete-char                          # Delete / Supr
bindkey '^[[C'  forward-char                         # →
bindkey '^[[D'  backward-char                        # ←

# ----------------------------------------------------------------
# PAGE UP / PAGE DOWN (historial)
# ----------------------------------------------------------------
bindkey '^[[5~' history-beginning-search-backward    # Page Up
bindkey '^[[6~' history-beginning-search-forward     # Page Down

# ----------------------------------------------------------------
# CTRL + FLECHAS (navegación por palabras)
# ----------------------------------------------------------------
# Acumulamos las dos variantes que ya usabas en el viejo.
# NOTA: el viejo tenía comentado `^[[1;5D`, aquí lo activamos
# porque el diagnóstico con showkey -a confirmó que foot lo envía.
bindkey '^[Oc'    forward-word                       # Ctrl+→ (algunos)
bindkey '^[Od'    backward-word                      # Ctrl+← (algunos)
bindkey '^[[1;5C' forward-word                       # Ctrl+→ (otros)
bindkey '^[[1;5D' backward-word                      # Ctrl+← (otros)

# ----------------------------------------------------------------
# CTRL+BACKSPACE (borrar palabra)
# ----------------------------------------------------------------
# ⚠️ IMPORTANTE: solo definimos `^H`. NO definimos `^?`.
#
# Motivo: Zsh ya tiene `^?` → backward-delete-char por DEFECTO.
# Ese default es correcto (Backspace normal = borra carácter).
# Si lo sobreescribimos, rompemos el Backspace normal.
#
# En foot:
#   Backspace normal  → ^? → default de Zsh → borra carácter ✅
#   Ctrl+Backspace    → ^H → esta línea → borra palabra ✅
bindkey '^H' backward-kill-word

# ----------------------------------------------------------------
# SHIFT+TAB (undo)
# ----------------------------------------------------------------
bindkey '^[[Z' undo

# ----------------------------------------------------------------
# HISTORIAL: flechas ↑↓ con búsqueda por prefijo
# ----------------------------------------------------------------
# Ya se define en 40-plugins.zsh junto al plugin
# history-substring-search. NO duplicar aquí.

# ----------------------------------------------------------------
# HistAI y HistAI_Preview
# ----------------------------------------------------------------
# Estos bindkeys sí van aquí porque están ligados a las funciones
# que definimos en ~/.config/zsh/functions/.
zle -N HistAI
bindkey '^k' HistAI                                  # Ctrl+K

zle -N HistAI_Preview
bindkey '^[p' HistAI_Preview                         # Alt+P
