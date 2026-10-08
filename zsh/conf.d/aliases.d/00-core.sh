# 00-core.sh
# ================================================================
# Aliases core: reemplazan comandos estándar por versiones mejoradas.
# Son los más "peligrosos" porque se ejecutan constantemente. Revisar
# con calma antes de añadir uno nuevo.
# ================================================================

# --- Navegación y limpieza ---
alias c='clear'
alias r='reset'
alias cd..='cd ..'

# --- Listado de archivos (lsd reemplaza ls) ---
alias ls='lsd'
alias ll='lsd -la --group-directories-first'
alias la='lsd -a --group-directories-first'

# --- Visualización de archivos ---
alias cat='bat'                # bat: cat con colores y números de línea
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# --- Copia, movimiento y borrado ---
# cp -i: pregunta antes de sobrescribir
# cp -r: recursivo
# cp -v: verbose (muestra qué copia)
# cp -f: fuerza (por si acaso)
alias cp='cp -irvf'
# mv -i: pregunta antes de sobrescribir
# mv -v: verbose
# mv -f: fuerza
alias mv='mv -ivf'
alias rm='sith-rm'             # wrapper propio (revisa que exista)
alias shred='shred -zf'

# --- Editor y herramientas ---
alias vi='vim'
alias wget="wget -c --user-agent 'noleak'"
alias dd='dd status=progress'  # OJO: puede romper scripts que parsean dd
alias rsync='echo "Ejecutamos rsync -avhp" && rsync -avhP'

# --- Sistema ---
alias grub-update="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias dracut-generate='sudo dracut --force /boot/initramfs-$(uname -r).img $(uname -r)'

# --- sudo/doas con espacio mágico ---
# El espacio final hace que el shell expanda el SIGUIENTE token como alias.
# Resultado: `sudo rm archivo` → `doas sith-rm archivo` (pasa por el script).
# Si no usas doas, cambia 'doas ' por 'sudo '.
alias sudo='sudo '
