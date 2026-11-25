#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2024-2026 Alonso Alvarado Hernández <alonsoalvaradohr>
# ==============================================================================
# CLISA SYSTEM FOUNDATION & OPTIMIZATION ORCHESTRATOR
# Target: Nobara Linux (Fedora 44 Base) // AMD Ryzen 7 7840HS Zen 4
# Idempotent System Hardening, Btrfs Balancing, sysctl & udev deployment
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "======================================================================"
echo " [CLISA-FOUNDATION] APLICANDO OPTIMIZACIONES DE NÚCLEO Y SISTEMA"
echo "======================================================================"

# 1. SYSCTL OPTIMIZATIONS (MEMORY + NETWORK)
echo "[1/7] Desplegando perfiles sysctl auditados en /etc/sysctl.d/ ..."
if [ -f "${SCRIPT_DIR}/config/99-clisa-mem.conf" ]; then
    cp "${SCRIPT_DIR}/config/99-clisa-mem.conf" /etc/sysctl.d/99-clisa-mem.conf
fi
if [ -f "${SCRIPT_DIR}/config/99-clisa-network.conf" ]; then
    cp "${SCRIPT_DIR}/config/99-clisa-network.conf" /etc/sysctl.d/99-clisa-network.conf
fi
sysctl --system >/dev/null 2>&1 || true

# 2. CPU GOVERNOR & AMD P-STATE EPP TUNING
echo "[2/7] Ajustando AMD P-State EPP a 'performance' para suprimir latencia..."
for epp in /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference; do
    [ -w "$epp" ] && echo "performance" > "$epp" 2>/dev/null || true
done
for gov in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    [ -w "$gov" ] && echo "performance" > "$gov" 2>/dev/null || true
done

# 3. BTRFS METADATA BALANCE
echo "[3/7] Ejecutando rebalanceo de metadatos BTRFS en raíz (/)..."
btrfs balance start -musage=10 / 2>/dev/null || btrfs balance start -m / 2>/dev/null || true

# 4. CORE SYSTEM DNF UPGRADE & CLEANUP
echo "[4/7] Sincronizando repositorios y actualizando core OS..."
dnf upgrade --refresh -y
dnf autoremove -y
dnf clean all

# 5. TILING & EMBEDDED SYSTEM PACKAGES
echo "[5/7] Verificando paquetería de Tiling UI, Toolchains y Embebidos..."
dnf install -y sway waybar rofi-wayland alacritty wl-clipboard \
    qt5-qtwayland qt6-qtgui openocd arm-none-eabi-gcc-cs arm-none-eabi-newlib \
    texlive-scheme-basic || true

# 6. FIRMWARE ALIGNMENT
echo "[6/7] Verificando actualizaciones de firmware de dispositivos..."
fwupdmgr get-updates || true

# 7. UDEV RULES & USER GROUPS (PLATFORMIO / EMBEDDED)
echo "[7/7] Inyectando reglas udev de instrumentación y grupos de usuario..."
if [ -f "${SCRIPT_DIR}/config/99-platformio-udev.rules" ]; then
    cp "${SCRIPT_DIR}/config/99-platformio-udev.rules" /etc/udev/rules.d/99-platformio-udev.rules
fi
if [ -f "${SCRIPT_DIR}/config/60-libsigrok.rules" ]; then
    cp "${SCRIPT_DIR}/config/60-libsigrok.rules" /etc/udev/rules.d/60-libsigrok.rules
fi
udevadm control --reload-rules || true
udevadm trigger || true

CURRENT_USER="${SUDO_USER:-$USER}"
usermod -a -G dialout,tty,uucp,lock "$CURRENT_USER" || true

echo "======================================================================"
echo " [✓] CIMENTACIÓN DE SISTEMA COMPLETADA EXITOSAMENTE"
echo "======================================================================"
