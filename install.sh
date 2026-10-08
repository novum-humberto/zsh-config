#!/usr/bin/env bash
# ================================================================
# install.sh — Instalador automático de zsh-config
#
# Uso:
#   ./install.sh                    # instalación interactiva
#   ./install.sh --unattended       # sin preguntas
#   ./install.sh --no-cryptosith    # no ofrecer instalar cryptosith
#
# Qué hace:
#   1. Detecta la distribución.
#   2. Verifica/instala dependencias.
#   3. Copia la config a ~/.config/zsh/.
#   4. Copia el bootstrap a ~/.zshenv.
#   5. Copia zsh-backup a ~/.local/bin/.
#   6. Ofrece instalar cryptosith (proyecto aparte).
#   7. Verifica la instalación.
#
# Repo: https://codeberg.org/novum-humberto/zsh-config
# ================================================================

set -euo pipefail

# --- Colores ---
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly BOLD='\033[1m'
readonly NC='\033[0m'

# --- Rutas ---
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly HOME_DIR="$HOME"
readonly ZSHENV_DST="$HOME/.zshenv"
readonly ZSH_DIR_DST="$HOME/.config/zsh"
readonly LOCAL_BIN="$HOME/.local/bin"
readonly TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

# --- Flags ---
UNATTENDED=false
NO_CRYPTOSITH=false

for arg in "$@"; do
    case "$arg" in
        --unattended)    UNATTENDED=true ;;
        --no-cryptosith) NO_CRYPTOSITH=true ;;
        -h|--help)
            echo "Uso: $0 [--unattended] [--no-cryptosith]"
            exit 0
            ;;
        *)
            echo "Flag desconocido: $arg"
            exit 1
            ;;
    esac
done

# ================================================================
# FUNCIONES AUXILIARES
# ================================================================
info()    { echo -e "${CYAN}→ $1${NC}"; }
ok()      { echo -e "${GREEN}✓ $1${NC}"; }
warn()    { echo -e "${YELLOW}⚠ $1${NC}"; }
err()     { echo -e "${RED}✗ $1${NC}" >&2; }
header()  { echo -e "${BOLD}$1${NC}"; }

die() {
    err "$1"
    exit 1
}

confirmar() {
    if $UNATTENDED; then return 0; fi
    local prompt="$1" resp
    read -rp "$prompt (s/N): " resp
    [[ "$resp" =~ ^[sSyY]$ ]]
}

pausa() {
    if ! $UNATTENDED; then
        echo ""
        read -rp "Presiona [Enter] para continuar..."
    fi
}

# Detectar distro
detect_distro() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        echo "${ID:-unknown}"
    else
        echo "unknown"
    fi
}

# ================================================================
# CABECERA
# ================================================================
clear
echo -e "${CYAN}"
cat <<'EOF'
╔══════════════════════════════════════════════════════╗
║          🔧 INSTALADOR DE ZSH-CONFIG 🔧              ║
║       Configuración modular de Zsh para Omarchy      ║
╚══════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

DISTRO="$(detect_distro)"
info "Distribución detectada: ${BOLD}$DISTRO${NC}"
info "Directorio del script: $SCRIPT_DIR"
echo ""

# ================================================================
# VERIFICAR QUE ESTAMOS EN EL REPO
# ================================================================
if [[ ! -d "$SCRIPT_DIR/zsh" ]] || [[ ! -f "$SCRIPT_DIR/zsh/zshenv" ]]; then
    die "No se encuentra la estructura del repo. Ejecuta este script desde la raíz del repo."
fi

# ================================================================
# VERIFICAR/INSTALAR DEPENDENCIAS
# ================================================================
header "──────────────────────────────────────────────────────"
header "  Paso 1: Verificar dependencias"
header "──────────────────────────────────────────────────────"
echo ""

# Paquetes base (nombres por distro)
case "$DISTRO" in
    arch|omarchy|manjaro|endeavouros)
        PKG_INSTALL="sudo pacman -S --needed --noconfirm"
        PKGS="zsh util-linux coreutils tar gnupg p7zip age fzf bat lsd fd ripgrep neovim less openssl"
        ;;
    debian|ubuntu|linuxmint|pop)
        PKG_INSTALL="sudo apt install -y"
        PKGS="zsh util-linux coreutils tar gnupg p7zip-full age fzf bat lsd fd-find ripgrep neovim less openssl"
        ;;
    fedora|rhel|centos)
        PKG_INSTALL="sudo dnf install -y"
        PKGS="zsh util-linux coreutils tar gnupg2 p7zip p7zip-plugins age fzf bat lsd fd-find ripgrep neovim less openssl"
        ;;
    opensuse*|suse)
        PKG_INSTALL="sudo zypper install -y"
        PKGS="zsh util-linux coreutils tar gpg2 p7zip age fzf bat lsd fd ripgrep neovim less openssl"
        ;;
    *)
        warn "Distribución no reconocida: $DISTRO"
        warn "Se asumirá Arch (pacman) por defecto."
        PKG_INSTALL="sudo pacman -S --needed --noconfirm"
        PKGS="zsh util-linux coreutils tar gnupg p7zip age fzf bat lsd fd ripgrep neovim less openssl"
        ;;
esac

# Verificar comandos críticos
MISSING=()
for cmd in zsh age script gpg 7z tar sha256sum; do
    if ! command -v "$cmd" &>/dev/null; then
        MISSING+=("$cmd")
    fi
done

if [[ ${#MISSING[@]} -eq 0 ]]; then
    ok "Todas las dependencias están instaladas."
else
    warn "Faltan los siguientes comandos: ${MISSING[*]}"
    echo ""
    if confirmar "¿Instalar dependencias ahora con '${PKG_INSTALL%% *}'?"; then
        info "Instalando dependencias..."
        $PKG_INSTALL $PKGS || die "Fallo al instalar dependencias."
        ok "Dependencias instaladas."
    else
        warn "Continuando sin instalar dependencias."
        warn "Algunos comandos pueden no funcionar hasta instalarlas."
    fi
fi

pausa

# ================================================================
# BACKUP DE LO EXISTENTE
# ================================================================
header "──────────────────────────────────────────────────────"
header "  Paso 2: Backup de la configuración actual"
header "──────────────────────────────────────────────────────"
echo ""

BACKUP_DIR="$HOME/.config/zsh.bak-$TIMESTAMP"
BACKUP_DONE=false

if [[ -f "$ZSHENV_DST" ]]; then
    info "Backup: $ZSHENV_DST → $ZSHENV_DST.bak-$TIMESTAMP"
    cp "$ZSHENV_DST" "$ZSHENV_DST.bak-$TIMESTAMP"
    BACKUP_DONE=true
fi

if [[ -d "$ZSH_DIR_DST" ]]; then
    info "Backup: $ZSH_DIR_DST → $BACKUP_DIR"
    mv "$ZSH_DIR_DST" "$BACKUP_DIR"
    BACKUP_DONE=true
fi

if $BACKUP_DONE; then
    ok "Backup guardado en: $HOME/.config/zsh.bak-$TIMESTAMP"
    echo -e "  y en: ${CYAN}$ZSHENV_DST.bak-$TIMESTAMP${NC}"
else
    info "No había config previa. Nada que respaldar."
fi

pausa

# ================================================================
# COPIAR ARCHIVOS
# ================================================================
header "──────────────────────────────────────────────────────"
header "  Paso 3: Copiar archivos"
header "──────────────────────────────────────────────────────"
echo ""

# 3.1. Crear estructura
info "Creando estructura de directorios..."
mkdir -p "$ZSH_DIR_DST/conf.d/aliases.d"
mkdir -p "$ZSH_DIR_DST/functions"
mkdir -p "$LOCAL_BIN"
ok "Estructura creada."

# 3.2. Bootstrap
info "Copiando ~/.zshenv..."
cp "$SCRIPT_DIR/zsh/zshenv" "$ZSHENV_DST"
ok "Copiado: $ZSHENV_DST"

# 3.3. Orquestador (renombrar a .zshrc)
info "Copiando orquestador (.zshrc)..."
cp "$SCRIPT_DIR/zsh/zshrc" "$ZSH_DIR_DST/.zshrc"
ok "Copiado: $ZSH_DIR_DST/.zshrc"

# 3.4. Fragmentos
info "Copiando fragmentos (conf.d/)..."
cp "$SCRIPT_DIR/zsh/conf.d/"*.zsh "$ZSH_DIR_DST/conf.d/"
ok "Copiados $(ls "$SCRIPT_DIR/zsh/conf.d/"*.zsh | wc -l) fragmentos."

# 3.5. Aliases
info "Copiando aliases (aliases.d/)..."
cp "$SCRIPT_DIR/zsh/conf.d/aliases.d/"*.sh "$ZSH_DIR_DST/conf.d/aliases.d/"
ok "Copiados $(ls "$SCRIPT_DIR/zsh/conf.d/aliases.d/"*.sh | wc -l) archivos de aliases."

# 3.6. Funciones
info "Copiando funciones (functions/)..."
cp "$SCRIPT_DIR/zsh/functions/"* "$ZSH_DIR_DST/functions/"
ok "Copiadas $(ls "$SCRIPT_DIR/zsh/functions/" | wc -l) funciones."

# 3.7. Script zsh-backup
info "Copiando zsh-backup a ~/.local/bin/..."
cp "$SCRIPT_DIR/scripts/zsh-backup" "$LOCAL_BIN/zsh-backup"
chmod +x "$LOCAL_BIN/zsh-backup"
ok "Copiado y dado permisos: $LOCAL_BIN/zsh-backup"

pausa

# ================================================================
# CRYPTOSITH (proyecto aparte)
# ================================================================
header "──────────────────────────────────────────────────────"
header "  Paso 4: cryptosith (proyecto aparte)"
header "──────────────────────────────────────────────────────"
echo ""

if $NO_CRYPTOSITH; then
    info "Omitido por flag --no-cryptosith."
elif confirmar "¿Quieres instalar cryptosith (cifrado por capas)?"; then
    echo ""
    echo -e "${CYAN}Cryptosith se descarga desde su propio repo:${NC}"
    echo -e "  ${YELLOW}https://codeberg.org/novum-humberto/cryptosith${NC}"
    echo ""
    echo -e "${YELLOW}Método 1 (recomendado): instalación automática${NC}"
    echo -e "  ${CYAN}bash <(curl -sSL https://codeberg.org/novum-humberto/cryptosith/raw/branch/main/install.sh)${NC}"
    echo ""
    echo -e "${YELLOW}Método 2: clonar e instalar manualmente${NC}"
    echo -e "  ${CYAN}git clone https://codeberg.org/novum-humberto/cryptosith.git /tmp/cryptosith${NC}"
    echo -e "  ${CYAN}cd /tmp/cryptosith && ./install.sh${NC}"
    echo ""
    info "Instálalo cuando quieras. Los archivos de este repo ya están listos."
else
    info "Omitido. Puedes instalarlo después desde su repo."
fi

pausa

# ================================================================
# VERIFICACIÓN
# ================================================================
header "──────────────────────────────────────────────────────"
header "  Paso 5: Verificación"
header "──────────────────────────────────────────────────────"
echo ""

ERRORS=0

# 5.1. Verificar zshenv
if [[ -f "$ZSHENV_DST" ]] && grep -q 'ZDOTDIR' "$ZSHENV_DST"; then
    ok "~/.zshenv existe y contiene ZDOTDIR."
else
    err "~/.zshenv no encontrado o mal formado."
    ((ERRORS++))
fi

# 5.2. Verificar .zshrc
if [[ -f "$ZSH_DIR_DST/.zshrc" ]]; then
    ok "~/.config/zsh/.zshrc existe."
else
    err "~/.config/zsh/.zshrc no encontrado."
    ((ERRORS++))
fi

# 5.3. Verificar fragmentos
N_FRAGMENTS=$(ls "$ZSH_DIR_DST/conf.d/"*.zsh 2>/dev/null | wc -l)
if [[ "$N_FRAGMENTS" -ge 12 ]]; then
    ok "Fragmentos: $N_FRAGMENTS (esperado ≥12)."
else
    err "Fragmentos: $N_FRAGMENTS (esperado ≥12)."
    ((ERRORS++))
fi

# 5.4. Verificar aliases
N_ALIASES=$(ls "$ZSH_DIR_DST/conf.d/aliases.d/"*.sh 2>/dev/null | wc -l)
if [[ "$N_ALIASES" -ge 12 ]]; then
    ok "Archivos de aliases: $N_ALIASES (esperado ≥12)."
else
    err "Archivos de aliases: $N_ALIASES (esperado ≥12)."
    ((ERRORS++))
fi

# 5.5. Verificar funciones
N_FUNCS=$(ls "$ZSH_DIR_DST/functions/" 2>/dev/null | wc -l)
if [[ "$N_FUNCS" -ge 11 ]]; then
    ok "Funciones: $N_FUNCS (esperado ≥11)."
else
    err "Funciones: $N_FUNCS (esperado ≥11)."
    ((ERRORS++))
fi

# 5.6. Verificar zsh-backup
if [[ -x "$LOCAL_BIN/zsh-backup" ]]; then
    ok "zsh-backup en ~/.local/bin/ y ejecutable."
else
    err "zsh-backup no encontrado o sin permisos."
    ((ERRORS++))
fi

echo ""

if [[ $ERRORS -eq 0 ]]; then
    ok "Verificación completa: todo OK."
else
    warn "Verificación completada con $ERRORS errores."
    warn "Revisa los mensajes de arriba."
fi

pausa

# ================================================================
# SIGUIENTE PASO
# ================================================================
header "──────────────────────────────────────────────────────"
header "  ✓ Instalación completada"
header "──────────────────────────────────────────────────────"
echo ""
echo -e "${GREEN}La configuración de Zsh está instalada.${NC}"
echo ""
echo -e "${YELLOW}⚠ IMPORTANTE:${NC}"
echo "  Este script NO cambia el shell por defecto (por seguridad)."
echo "  Debes configurar tu terminal para que lance Zsh."
echo ""
echo -e "${CYAN}Siguiente paso:${NC}"
echo ""
echo -e "  ${BOLD}Si usas Omarchy + foot:${NC}"
echo "    1. Edita ~/.config/foot/foot.ini"
echo "    2. Añade: ${YELLOW}shell=/usr/bin/zsh${NC} dentro de [main]"
echo "    3. Cierra TODAS las ventanas de foot"
echo "    4. Abre una nueva"
echo ""
echo -e "  ${BOLD}Si usas otra distro:${NC}"
echo "    chsh -s /usr/bin/zsh"
echo ""
echo -e "${CYAN}Verificar después de reiniciar la terminal:${NC}"
echo -e "  ${YELLOW}echo \$ZDOTDIR${NC}    → /home/$USER/.config/zsh"
echo -e "  ${YELLOW}menu${NC}              → menú central"
echo -e "  ${YELLOW}cryp help${NC}         → si instalaste cryptosith"
echo -e "  ${YELLOW}time zsh -i -c 'exit'${NC} → tiempo de arranque"
echo ""

if $BACKUP_DONE; then
    echo -e "${CYAN}Backup de tu config anterior:${NC}"
    echo -e "  ${YELLOW}$HOME/.config/zsh.bak-$TIMESTAMP${NC}"
    echo -e "  ${YELLOW}$ZSHENV_DST.bak-$TIMESTAMP${NC}"
    echo ""
    echo "  Si algo va mal, puedes restaurar con:"
    echo -e "  ${CYAN}mv $HOME/.config/zsh.bak-$TIMESTAMP $ZSH_DIR_DST${NC}"
    echo -e "  ${CYAN}mv $ZSHENV_DST.bak-$TIMESTAMP $ZSHENV_DST${NC}"
    echo ""
fi

echo -e "${GREEN}¡Disfruta tu nueva config de Zsh!${NC}"
echo ""
