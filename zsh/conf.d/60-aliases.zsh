# 60-aliases.zsh
# ================================================================
# Índice de aliases. NO poner aliases aquí, solo cargar los fragmentos
# de aliases.d/ en orden. Cada fragmento agrupa por categoría.
# ================================================================

for f in "$ZDOTDIR"/conf.d/aliases.d/[0-9][0-9]-*.sh(N); do
    source "$f"
done
