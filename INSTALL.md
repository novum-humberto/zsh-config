# INSTALL

Guía detallada de instalación de `zsh-config`   en Linux.

---

## 📋 Índice

1. [Requisitos previos](#1-requisitos-previos)
2. [Instalación automática (recomendada)](#2-instalación-automática-recomendada)
3. [Instalación manual paso a paso](#3-instalación-manual-paso-a-paso)
4. [Configurar terminal (foot)](#4-configurar-terminal-foot)
5. [Verificación](#5-verificación)
6. [Instalación de cryptosith (proyecto aparte)](#6-instalación-de-cryptosith-proyecto-aparte)
7. [Multi-distro (Debian, Fedora, etc.)](#7-multi-distro)
8. [Desinstalación](#8-desinstalación)
9. [Troubleshooting](#9-troubleshooting)

---

## 1. Requisitos previos

### Sistema

- Distro linux cualquiera (Pero como uso Omarchy o Arch puro muchas osas fueron pensadas para estas distros) con:
  - `systemd`
  - `pacman` o `yay`/`paru` para AUR ( este proyecto ha sido hecho en base al ecosistema de Arch. Puede ser usada en cualqueir distro linux con systemd, pero habria que revisar los aliases y algunas funciones hacerle modificaciones) 
  - `foot` como terminal (o adaptar la sección 4)

### Acceso

- Usuario normal (no `root`).
- Capacidad de usar `sudo`.
- Conexión a Internet (para instalar dependencias).


## 2. Instalación automática (recomendada)

### Una sola línea

```bash
bash <(curl -sSL https://codeberg.org/novum-humberto/zsh-config/raw/branch/main/install.sh)
```

**Qué hace**:

1. Detecta la distribución.
2. Instala las dependencias que falten.
3. Copia `zshenv` a `~/.zshenv`.
4. Copia `zshrc` (renombrado a `.zshrc`) a `~/.config/zsh/`.
5. Copia `conf.d/` y `functions/`.
6. Copia `zsh-backup` a `~/.local/bin/`.
7. Ofrece instalar `cryptosith` (opcional).
8. Muestra los siguientes pasos.

**El script es idempotente**: se puede ejecutar varias veces sin romper nada. Antes de sobrescribir, guarda un backup en `.bak-TIMESTAMP`.

### Instalación desde repo clonado

```bash
git clone https://codeberg.org/novum-humberto/zsh-config.git
cd zsh-config
./install.sh
```

---

## 3. Instalación manual paso a paso

### 3.1. Dependencias

**Verificar paquetes instalados**:

```bash
for cmd in zsh age script gpg 7z tar sha256sum mktemp realpath; do
    printf "%-12s " "$cmd"
    command -v "$cmd" &>/dev/null && echo "OK" || echo "FALTA"
done
```

**Instalar lo que falte** (Arch):

```bash
sudo pacman -S --needed \
    zsh util-linux coreutils tar \
    gnupg p7zip age \
    fzf bat lsd fd ripgrep \
    neovim less openssl
```

### 3.2. Estructura de directorios

```bash
mkdir -p ~/.config/zsh/conf.d/aliases.d
mkdir -p ~/.config/zsh/functions
mkdir -p ~/.local/bin
```

### 3.3. Copiar archivos

Asumiendo que estás dentro del repo clonado (`cd zsh-config`):

```bash
# 1. Bootstrap
cp zsh/zshenv ~/.zshenv

# 2. Orquestador (renombrar a .zshrc)
cp zsh/zshrc ~/.config/zsh/.zshrc

# 3. Fragmentos
cp zsh/conf.d/*.zsh ~/.config/zsh/conf.d/

# 4. Aliases
cp zsh/conf.d/aliases.d/*.sh ~/.config/zsh/conf.d/aliases.d/

# 5. Funciones
cp zsh/functions/* ~/.config/zsh/functions/

# 6. Script de backup
cp scripts/zsh-backup ~/.local/bin/
chmod +x ~/.local/bin/zsh-backup
```

### 3.4. Verificar estructura

```bash
# Verificar .zshenv
cat ~/.zshenv
# Debe decir: export ZDOTDIR="$HOME/.config/zsh"

# Verificar fragmentos
ls ~/.config/zsh/conf.d/*.zsh | wc -l
# Debe ser 12

# Verificar aliases
ls ~/.config/zsh/conf.d/aliases.d/*.sh | wc -l
# Debe ser 12

# Verificar funciones
ls ~/.config/zsh/functions/ | wc -l
# Debe ser 11 (o 13 si instalas cryptosith)

# Verificar script
ls -la ~/.local/bin/zsh-backup
# Debe ser ejecutable (-rwxr-xr-x)
```

---

## 4. Configurar terminal (foot)

**Importante**: en Omarchy, **NO se usa `chsh`** para cambiar el shell por defecto. Rompe el arranque del sistema. La forma correcta es configurar el terminal para que lance Zsh.

### Editar `foot.ini`

```bash
nvim ~/.config/foot/foot.ini
```

Añadir/modificar dentro de `[main]`:

```ini
[main]
shell=/usr/bin/zsh
```

**Si el archivo no existe**, créalo:

```bash
nvim ~/.config/foot/foot.ini
```

Contenido mínimo:

```ini
[main]
shell=/usr/bin/zsh
```

### Cerrar TODAS las ventanas de foot

El protocolo se negocia al abrir la ventana. Hay que cerrar **todas** las instancias para que se aplique.

### Otras terminales

Si usas otras terminales:

| Terminal | Configuración |
|----------|--------------|
| **Alacritty** | `shell: { program: /usr/bin/zsh }` en `alacritty.toml` |
| **Kitty** | `shell /usr/bin/zsh` en `kitty.conf` |
| **WezTerm** | `config.default_prog = { '/usr/bin/zsh' }` en `wezterm.lua` |
| **Konsole** | Perfil → Comando → `/usr/bin/zsh` |
| **Tilix** | Perfil → Comando → Shell personalizado → `/usr/bin/zsh` |

---

## 5. Verificación

Abre una **terminal nueva**. Debería cargar Zsh automáticamente.

### 5.1. Verificar shell

```bash
echo $ZDOTDIR
# → /home/tuuser/.config/zsh

echo $ZSH_VERSION
# → 5.9 (o la versión que tengas)

echo $SHELL
# → /usr/bin/bash  (el login sigue siendo bash, PERO estás dentro de Zsh)
```

### 5.2. Verificar tiempo de arranque

```bash
time zsh -i -c 'exit'
# → ~0.05s
```

Si tarda más de 1 segundo → algo va mal. Ver [Troubleshooting](#9-troubleshooting).

### 5.3. Verificar componentes

```bash
# Aliases
alias ls
# → ls='lsd'

alias cat
# → cat='bat'

# Funciones
type menu-principal
# → menu-principal is a shell function from ...

type mantenimiento
# → mantenimiento is a shell function from ...

type ufw-manager
# → ufw-manager is a shell function from ...

# Prompt
# Debe verse así:
# ┌──[ tuuser ]──( 🏠 )
# └─➤

# Autocompletado
menu <TAB><TAB>
# → Muestra opciones del menú

# Menú central
menu
# → Se abre el menú principal
# Pulsa 0 para salir.
```

### 5.4. Test de cryptosith (si lo instalaste)

```bash
cd /tmp
echo "test" > t.txt
cryp encrypt t.txt -t
# Passphrase: prueba

mv t.txt t.orig
cryp decrypt t.txt.sith
diff t.txt t.orig && echo "OK cryptosith"

/bin/rm -f t.txt*
```

### 5.5. Test de backup

```bash
zsh-backup
# Debe abrir el menú de backup/restauración.
# Pulsa 3 para ver info.
# Pulsa 0 para salir.
```

---

## 6. Instalación de cryptosith (proyecto aparte)

`cryptosith` es un proyecto **separado**. No está incluido en este repo.

### Instalación automática

```bash
bash <(curl -sSL https://codeberg.org/novum-humberto/cryptosith/raw/branch/main/install.sh)
```

### Instalación manual

```bash
# 1. Clonar
git clone https://codeberg.org/novum-humberto/cryptosith.git
cd cryptosith

# 2. Copiar archivos
cp cryptosith ~/.config/zsh/functions/cryptosith
cp _cryptosith ~/.config/zsh/functions/_cryptosith
chmod +x ~/.config/zsh/functions/cryptosith
chmod +x ~/.config/zsh/functions/_cryptosith

# 3. Manual
mkdir -p ~/.config/cryptosith
cp manual.txt ~/.config/cryptosith/manual.txt

# 4. Verificar autoload en .zshrc
grep "_cryptosith" ~/.config/zsh/.zshrc
# Si no aparece, añadirlo al autoload -Uz.

# 5. Recargar
exec zsh

# 6. Verificar
cryp help
```

### Verificar instalación

```bash
type cryptosith
# → function from ...

cryp help
# → Muestra la ayuda

cryp man
# → Abre el manual
```

**Nota**: si `menu-principal` no detecta `cryptosith` al pulsar la opción 2, mostrará un aviso pidiéndote que lo instales. Una vez instalado, la opción funcionará automáticamente.

---

## 7. Multi-distro

Esta config está pensada para **Arch/Omarchy**, pero funciona en otras distros con ajustes.

### Debian / Ubuntu / Linux Mint

**Instalar dependencias**:

```bash
sudo apt update
sudo apt install \
    zsh util-linux coreutils tar \
    gnupg p7zip-full age \
    fzf bat lsd fd-find ripgrep \
    neovim less openssl
```

**Diferencias**:
- `fd` se llama `fd-find` → el binario es `fdfind`, no `fd`. Añadir alias:
  ```zsh
  alias fd='fdfind'
  ```
- `bat` se llama `batcat` → el binario es `batcat`, no `bat`. Añadir alias:
  ```zsh
  alias bat='batcat'
  ```

### Fedora / RHEL

```bash
sudo dnf install \
    zsh util-linux coreutils tar \
    gnupg2 p7zip p7zip-plugins age \
    fzf bat lsd fd-find ripgrep \
    neovim less openssl
```

### openSUSE

```bash
sudo zypper install \
    zsh util-linux coreutils tar \
    gpg2 p7zip age \
    fzf bat lsd fd ripgrep \
    neovim less openssl
```

### Notas multi-distro

- **`chsh`** en estas distros **SÍ funciona**. Se puede cambiar el shell por defecto:
  ```bash
  chsh -s /usr/bin/zsh
  ```
- **En Omarchy**: **NO usar `chsh`**. Usar `foot.ini` (ver sección 4).
- **Los aliases personales** (`~/Scripts_Mios/`, `~/Vault/Logs/`, etc.) **no existirán** en otra distro. Editar `aliases.d/80-scripts.sh` y `aliases.d/90-misc.sh` para adaptarlos.

---

## 8. Desinstalación

### Restaurar Bash

**En Omarchy**:

```bash
# Editar foot.ini y quitar la línea shell=/usr/bin/zsh
nvim ~/.config/foot/foot.ini

# Cerrar todas las ventanas de foot.
```

**En otras distros** (si usaste `chsh`):

```bash
chsh -s /bin/bash
```

### Eliminar archivos

```bash
# Bootstrap
command rm -f ~/.zshenv

# Configuración
command rm -rf ~/.config/zsh

# Script
command rm -f ~/.local/bin/zsh-backup

# Manual de cryptosith (si lo instalaste)
command rm -rf ~/.config/cryptosith
```

**Nota**: si tenías backup de la config vieja (`~/.zshrc.OLD`), no la tocamos. Podrás volver a Bash con el `.zshrc` original.

---

## 9. Troubleshooting

### El prompt se ve literal (`$(dynamic_prompt)...`)

**Causa**: `PROMPT_SUBST` no está activo.

**Solución**:

```bash
grep PROMPT_SUBST ~/.config/zsh/conf.d/00-options.zsh
# Debe estar la línea: setopt PROMPT_SUBST
```

Si no está:
```bash
echo "setopt PROMPT_SUBST" >> ~/.config/zsh/conf.d/00-options.zsh
exec zsh
```

### Las funciones no cargan

**Causa**: `autoload -Uz` incompleto en `.zshrc`.

**Solución**:

```bash
cat ~/.config/zsh/.zshrc | grep -A 10 "autoload -Uz"
```

Debe listar todas las funciones. Si falta alguna, añadirla.

### El autocompletado no funciona

**Causa probable**: `fpath` está después de `compinit`.

**Solución**:

```bash
head -20 ~/.config/zsh/.zshrc
```

Debe verse así:
```zsh
# fpath PRIMERO
fpath=("$ZDOTDIR/functions" $fpath)

# Luego cargar conf.d/
for f in "$ZDOTDIR"/conf.d/[0-9][0-9]-*.zsh(N); do
    source "$f"
done

# Luego autoload
autoload -Uz ...
```

Si el `fpath` está después del bucle → **moverlo al principio**.

### Los emojis del prompt se ven como basura

**Causa**: locale no es UTF-8.

**Solución**:

```bash
locale
# Verificar que LANG tiene .UTF-8
```

Si no:
```bash
sudo nvim /etc/locale.conf
```

Contenido:
```
LANG=en_US.UTF-8
```

Y:
```bash
sudo locale-gen
```

### El arranque tarda >1 segundo

**Causa**: probablemente `compinit` no usa caché.

**Solución**:

```bash
ls -la ~/.config/zsh/.zcompdump
# Debe existir (54 KB aprox)

# Si no existe, forzar regeneración
rm -f ~/.config/zsh/.zcompdump*
exec zsh
```

### `menu-principal` muestra la opción 2 (cryptosith) rota

**Causa**: cryptosith no está instalado.

**Solución**: instalarlo (ver sección 6).

### Los aliases de `~/Scripts_Mios` no funcionan

**Causa**: no tienes esos scripts.

**Solución**: editar los aliases y comentar los que apunten a scripts que no tienes:

```bash
nvim ~/.config/zsh/conf.d/aliases.d/80-scripts.sh
```

Comentar las líneas:
```zsh
# alias temp-hd='$HOME/Scripts_Mios/check_temps_smartctl.sh'
# alias update='sh ~/Scripts_Mios/Genericos/ragnarok/ragnarok.sh'
# ...
```

### La terminal no lanza Zsh

**Causa**: `foot.ini` mal configurado, o no cerraste todas las ventanas.

**Solución**:

```bash
cat ~/.config/foot/foot.ini | grep shell
# Debe decir: shell=/usr/bin/zsh

# Cerrar TODAS las ventanas de foot.
# Abrir una nueva.
```

### Necesito volver a Bash temporalmente

```bash
bash
# Estás en Bash. Cuando termines:
exit
# Vuelves a Zsh.
```

O para un login shell:
```bash
exec bash -l
```

---

## 📌 Siguiente paso

Después de instalar, lee:

- **[README.md](README.md)** — presentación del proyecto.
- **[LESSONS.md](LESSONS.md)** — lecciones aprendidas.
- **Manual de cryptosith** — en su propio repo.

---

## 🎓 Créditos

Proyecto personal. Sin ánimo de lucro. Sin garantías.

Inspirado en la filosofía de [Omarchy](https://omarchy.org).

---

**Última actualización**: 2026-10-07.
```

**Guardar** con `Esc`, `:wq`.

---

## 📋 Verificar y añadir al repo

```bash
# 1. Verificar que se guardó
wc -l INSTALL.md
# → ~330 líneas

# 2. Añadir al git
git add INSTALL.md

# 3. Ver qué hay listo para commit
git status
```

---

