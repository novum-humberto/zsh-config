# 80-hooks.zsh
# ================================================================
# HOOKS DE ZSH
# ================================================================
# Un "hook" es una función que Zsh ejecuta AUTOMÁTICAMENTE en un
# momento concreto del ciclo del shell. Tú no la llamas; Zsh la
# llama por ti cuando toca.
#
# Los 3 hooks principales de Zsh:
#
#   ┌────────────┬──────────────────────────┬───────────────────────┐
#   │ HOOK       │ CUÁNDO SE EJECUTA        │ USO TÍPICO            │
#   ├────────────┼──────────────────────────┼───────────────────────┤
#   │ precmd     │ Antes de mostrar prompt  │ Actualizar prompt     │
#   │ preexec    │ Antes de ejecutar cmd    │ Título, notificac.    │
#   │ chpwd      │ Al cambiar de directorio │ Activar venv, etc.    │
#   └────────────┴──────────────────────────┴───────────────────────┘
#
# En este archivo usamos SOLO el hook `precmd` para actualizar la
# información de Git que muestra el prompt.
#
# ----------------------------------------------------------------
# REGLA DE ORO: add-zsh-hook vs precmd()
# ----------------------------------------------------------------
# Hay dos formas de registrar un hook precmd:
#
#   ❌ FORMA ANTIGUA (mala):
#        precmd() { vcs_info }
#      SOBRESCRIBE. Si dos plugins quieren usar precmd, el último
#      pisa al primero. Los demás se pierden sin avisar.
#
#   ✅ FORMA MODERNA (buena):
#        add-zsh-hook precmd _mi_funcion
#      ACUMULA. Puedes registrar múltiples funciones para el mismo
#      hook y TODAS se ejecutan en orden.
#
# Por eso en esta config usamos SIEMPRE add-zsh-hook.
# ================================================================


# ----------------------------------------------------------------
# 1. Cargar la función add-zsh-hook
# ----------------------------------------------------------------
# add-zsh-hook no está disponible por defecto. Hay que cargarla.
# `autoload -Uz` la registra sin ejecutarla todavía (carga perezosa).
#   -U → no expandir aliases dentro de la función.
#   -z → usar el estilo nativo de Zsh.
autoload -Uz add-zsh-hook


# ----------------------------------------------------------------
# 2. Definir la función que se ejecutará en precmd
# ----------------------------------------------------------------
# Esta función llama a `vcs_info`, la utilidad de Zsh que consulta
# el estado del repositorio Git del directorio actual.
#
# ¿Qué hace vcs_info?
#   - Detecta si estás en un repo Git.
#   - Obtiene la rama actual (main, dev, etc.).
#   - Detecta cambios sin commitear, archivos sin trackear, etc.
#   - Guarda el resultado en la variable $vcs_info_msg_0_.
#
# Esa variable es la que tu prompt usa:
#   PROMPT='$(dynamic_prompt)${vcs_info_msg_0_}'
#
# Sin este hook, $vcs_info_msg_0_ estaría vacío y nunca verías
# [⎇ main] en el prompt.
#
# ¿Por qué es una función y no llamamos a vcs_info directamente?
#   Porque add-zsh-hook solo acepta funciones, no comandos sueltos.
#
# ¿Por qué el guion bajo al principio del nombre?
#   Convención para indicar "función interna, no la uses tú".
_vcs_info_precmd() {
    vcs_info
}


# ----------------------------------------------------------------
# 3. Registrar la función como hook precmd
# ----------------------------------------------------------------
# Sintaxis: add-zsh-hook <tipo> <función>
#
# Esto le dice a Zsh:
#   "Cada vez que vayas a mostrar el prompt, ejecuta _vcs_info_precmd".
#
# Efecto: cada vez que pulsas Enter y el prompt vuelve a aparecer,
# Zsh consulta el estado de Git y actualiza $vcs_info_msg_0_.
# Así ves la rama actual siempre actualizada, aunque hayas cambiado
# de rama o hecho commits entre comandos.
add-zsh-hook precmd _vcs_info_precmd


# ----------------------------------------------------------------
# NOTAS Y PENDIENTES
# ----------------------------------------------------------------
# Hooks que NO migramos desde el .zshrc viejo:
#
#   xterm_title_precmd  → cambiaba el título de ventana con
#                          "usuario@host ruta" antes del prompt.
#
#   xterm_title_preexec → añadía el comando al título durante
#                          su ejecución.
#
# Ambos se omitieron porque el usuario no usa el título de ventana
# (si se pierde, usa `pwd`). Si algún día se quieren recuperar,
# se añaden con add-zsh-hook en este mismo archivo.
#
#
# CÓMO VER LOS HOOKS REGISTRADOS:
#
#   add-zsh-hook -L          # todos los hooks
#   add-zsh-hook -L precmd   # solo precmd
#   add-zsh-hook -L preexec  # solo preexec
#
#
# CÓMO AÑADIR UN HOOK NUEVO (ejemplo):
#
#   # Notificar cuando un comando tarda más de 30 segundos.
#   _notify_long_command_precmd() {
#       if [[ -n "$_cmd_start_time" ]]; then
#           local elapsed=$(( EPOCHSECONDS - _cmd_start_time ))
#           if (( elapsed > 30 )); then
#               notify-send "Comando completado" "Tardó ${elapsed}s"
#           fi
#           unset _cmd_start_time
#       fi
#   }
#
#   _notify_long_command_preexec() {
#       _cmd_start_time=$EPOCHSECONDS
#   }
#
#   add-zsh-hook precmd _notify_long_command_precmd
#   add-zsh-hook preexec _notify_long_command_preexec
