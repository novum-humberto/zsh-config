# 30-pacman-yay.sh
# ================================================================
# Aliases de pacman y yay: actualización, limpieza, mirrors.
#
# ⚠️ Los alias `pau`, `yau` y `full-update` usan --noconfirm.
# Esto significa que NO preguntan nada al actualizar. Cómodo pero
# peligroso: si hay conflictos, fallan sin avisar.
# ================================================================

# --- Refrescar mirrors (movido desde 00-core.sh) ---
alias mirrors="sudo reflector --verbose --latest 5 --country 'United States' --age 6 --sort rate --save /etc/pacman.d/mirrorlist"

# --- Actualizar sistema ---
alias pau='echo "Sincronizar, servidores y actualizar con sudo pacman -Syu" && sudo pacman -Syu'
alias yau="yay -Syu --noconfirm"
alias full-update="sudo reflector --verbose --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist && sudo pacman -Syu --noconfirm && yay -Syu --noconfirm && flatpak update -y"

# --- Limpieza ---
# purga: elimina paquetes huérfanos y sus dependencias
# -Rns: R=remove, n=no-save (config), s=recursivo (dependencias)
# $(pacman -Qtdq): lista de paquetes huérfanos (Q=query, t=orphans, d=deps, q=quiet)
alias purga='sudo pacman -Rns $(pacman -Qtdq)'

