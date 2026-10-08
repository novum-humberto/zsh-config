# 10-history.zsh
# ================================================================
# Historial. Tus opciones actuales, consolidadas.
# ================================================================

HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000000
SAVEHIST=1000000

# --- Escritura y compartido ---
setopt INC_APPEND_HISTORY      # escribe cada comando INMEDIATAMENTE
setopt SHARE_HISTORY           # comparte historial entre terminales

# --- Control de duplicados ---
setopt HIST_IGNORE_ALL_DUPS    # elimina duplicados antiguos al guardar
setopt HIST_EXPIRE_DUPS_FIRST  # al limitar, quita primero duplicados viejos
setopt HIST_IGNORE_DUPS        # no guarda duplicados consecutivos
setopt HIST_FIND_NO_DUPS       # no muestra duplicados al buscar

# --- Calidad del historial ---
setopt HIST_IGNORE_SPACE       # ignora comandos que empiezan con espacio
setopt HIST_REDUCE_BLANKS      # limpia espacios sobrantes antes de guardar
setopt HIST_VERIFY             # muestra el comando antes de ejecutar al expandir

# Comandos que NUNCA van al historial
HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"
