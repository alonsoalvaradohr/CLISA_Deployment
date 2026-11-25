# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2024-2026 Alonso Alvarado Hernández <alonsoalvaradohr>
# ==============================================================================
# CLISA OPERATOR ALIASES & SHELL ACCELERATORS (ZERO COGNITIVE LATENCY)
# ==============================================================================

# 1. ZOXIDE & FZF INTEGRATION
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init bash)"
fi

if command -v fzf >/dev/null 2>&1; then
    eval "$(fzf --bash 2>/dev/null || true)"
fi

# 2. JAVA / HIDPI RENDERING FLAGS FOR MATLAB & SIMULINK
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dsun.java2d.uiScale=1.0"
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export GDK_SCALE=1

# 3. PROJECT NAVIGATION SHORTCUTS
alias cmu='cd ${RND_WORKSPACE:-/opt/rnd_workspace} && ls -la'
alias danybot='cd ${CLISA_ROOT:-/opt/clisa} && ls -la'
alias rnd='cd ${RND_WORKSPACE:-/opt/rnd_workspace}'
alias clisa-dir='cd ${CLISA_ROOT:-/opt/clisa}'

# 4. ENGINEERING TOOLS SHORTCUTS
alias clisa-cad='${USER_LOCAL:-~/.local}/bin/clisa-fusion-launch.sh'
alias clisa-matlab='${USER_LOCAL:-~/.local}/bin/matlab -desktop'
alias clisa-matlab-cli='${USER_LOCAL:-~/.local}/bin/matlab -nodesktop -nosplash'
alias clisa-thermal='${CLISA_ROOT:-/opt/clisa}/scripts/clisa_thermal_governance.sh'
alias clisa-power='${CLISA_ROOT:-/opt/clisa}/scripts/clisa_power_governor.sh'
alias clisa-audit='cat ${CLISA_ROOT:-/opt/clisa}/COMMAND_EXECUTION_AUDIT.md'
alias clisa-nvme-check='lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINTS /dev/nvme1n1'
alias clisa-pio-build='pio run'
alias clisa-serial='picocom -b 115200 /dev/ttyACM0'

# Fast LaTeX compilation function
clisa-latex() {
    if [ -z "${1:-}" ]; then
        echo "Uso: clisa-latex <archivo.tex>"
        return 1
    fi
    pdflatex -halt-on-error -interaction=nonstopmode "$1" && echo "[✓] PDF generado exitosamente: ${1%.tex}.pdf"
}

# General System Telemetry
clisa-status() {
    echo "======================================================================"
    echo " [CLISA-CORE] TELEMETRÍA GLOBAL DE LA ESTACIÓN DE TRABAJO"
    echo "======================================================================"
    echo "--- [1] SALUD TÉRMICA Y CPU ---"
    sensors 2>/dev/null | grep -A 1 "k10temp" || true
    cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq 2>/dev/null | awk '{printf "Core 0 Freq: %.1f MHz\n", $1/1000}'
    echo "--- [2] SINCRONIZACIÓN HORARIA & RTC ---"
    timedatectl | grep -E "Local time|RTC in local TZ|synchronized"
    echo "--- [3] AISLAMIENTO DISCO WINDOWS (nvme1n1) ---"
    lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINTS /dev/nvme1n1
    echo "--- [4] HIPERVISOR KVM ---"
    virsh --connect qemu:///system list --all 2>/dev/null || echo "KVM Daemon Ready"
    echo "======================================================================"
}
