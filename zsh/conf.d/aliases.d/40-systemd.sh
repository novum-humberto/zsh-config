# 40-systemd.sh
# ================================================================
# Aliases genéricos de systemd (systemctl) y estado del sistema.
# Los servicios específicos (vpn, bluetooth, ollama) van en
# 42-services.sh para mantener este archivo corto y legible.
# ================================================================

# --- systemctl con sudo (sc-*) ---
# Todos los comandos que modifican estado requieren sudo.
alias sc-start='sudo systemctl start'
alias sc-stop='sudo systemctl stop'
alias sc-restart='sudo systemctl restart'
alias sc-reload='sudo systemctl reload'
alias sc-enable='sudo systemctl enable'
alias sc-disable='sudo systemctl disable'
alias sc-enable-now='sudo systemctl enable --now'
alias sc-disable-now='sudo systemctl disable --now'
alias sc-mask='sudo systemctl mask'
alias sc-unmask='sudo systemctl unmask'
alias sc-mask-now='sudo systemctl mask --now'
alias sc-unmask-now='sudo systemctl unmask --now'
alias sc-edit='sudo systemctl edit'
alias sc-reset-failed='sudo systemctl reset-failed'
alias sc-kill='sudo systemctl kill'
alias sc-link='sudo systemctl link'
alias sc-preset='sudo systemctl preset'
alias sc-reenable='sudo systemctl reenable'
alias sc-set-default='sudo systemctl set-default'
alias sc-daemon-reload='sudo systemctl daemon-reload'
alias sc-isolate='sudo systemctl isolate'
alias sc-switch-root='sudo systemctl switch-root'
alias sc-cancel='sudo systemctl cancel'

# --- Consulta (sin sudo) ---
alias sc-status='systemctl status'
alias sc-is-active='systemctl is-active'
alias sc-is-enabled='systemctl is-enabled'
alias sc-list-units='systemctl list-units'
alias sc-list-unit-files='systemctl list-unit-files'
alias sc-list-timers='systemctl list-timers'
alias sc-list-jobs='systemctl list-jobs'
alias sc-cat='systemctl cat'
alias sc-help='systemctl help'
alias sc-get-default='systemctl get-default'
alias sc-show='systemctl show'

# --- Energía (hibernate/suspend) ---
alias sc-hibernate='sudo systemctl hibernate'
alias sc-hybrid-sleep='sudo systemctl hybrid-sleep'
alias sc-suspend='sudo systemctl suspend'

# --- Verificación de servicios críticos ---
alias thermal-status='systemctl status thermald.service --no-pager -l'
alias preload-status='systemctl status preload.service --no-pager -l'

# --- Análisis general del sistema ---
alias services-enabled='systemctl list-unit-files --type=service --state=enabled'
alias boot-analysis='systemd-analyze && systemd-analyze blame'
alias failed-services='systemctl --failed --all'
alias info-system='echo -e "\033[1;32m=== MONITOREO DEL SISTEMA ===\033[0m\nthermal-status     # Estado de control t\u00e9rmico\npreload-status     # Estado de precarga\nservices-enabled   # Servicios habilitados\nboot-analysis      # An\u00e1lisis de tiempo de arranque\nfailed-services    # Servicios fallidos"'

# --- Máquinas virtuales (libvirt) ---
alias vm-on='sudo systemctl start libvirtd.service'
alias vm-off='sudo systemctl stop libvirtd.service'
