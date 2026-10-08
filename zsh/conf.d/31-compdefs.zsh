# 31-compdefs.zsh
# ================================================================
# Registro de funciones de autocompletado.
#
# Este archivo se carga DESPUÉS de 30-completion.zsh (que ejecuta
# compinit). Aquí registramos los compdefs de nuestras funciones.
#
# ¿Por qué no poner los compdefs en los propios archivos _funcion?
# Porque los archivos _funcion solo se cargan cuando Zsh los necesita,
# y Zsh no los necesita hasta que sabe que existen. Círculo vicioso.
#
# Solución: registrar los compdefs aquí, al inicio del shell.
# ================================================================

# Registrar autocompletado para cryptosith
compdef _cryptosith cryptosith
