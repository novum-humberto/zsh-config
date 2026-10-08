# 10-fs.sh
# ================================================================
# Aliases de sistema de archivos: df, du, free.
#
# ⚠️ df y du reemplazan comandos estándar por TUIs (dysk, ncdu).
# En scripts usar `command df` o `command du` para evitar el alias.
# ================================================================

# --- Espacio en disco ---
alias df='dysk'           # df moderno, TUI (antes: df -h)

# --- Uso por directorio ---
alias du='ncdu'           # analizador de disco interactivo (antes: du -sch)

# --- Memoria ---
alias free='free -h'      # formato humano (GiB/MiB en vez de bytes)
