# 60-aliases.zsh
# ================================================================
# Índice de aliases. NO poner aliases aquí, solo cargar los fragmentos
# de aliases.d/ en orden. Cada fragmento agrupa por categoría.
# ================================================================

for f in "$ZDOTDIR"/conf.d/aliases.d/[0-9][0-9]-*.sh(N); do
    source "$f"
done

# Cargar automáticamente todos mis aliases de solución de errores
for f in "$ZDOTDIR"/conf.d/aliases.d/fixes/errors-corretion/[0-9][0-9]-*.sh(N); do
    source "$f"
done
