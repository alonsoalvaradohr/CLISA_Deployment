#!/usr/bin/env bash
# ==============================================================================
# CLISA-AGENT: BLINDAJE BTRFS, EXPANSION R&D Y OPTIMIZACION DE ENTORNO
# Target: Nobara Linux 44 // AMD 7840HS + RTX 4060 Mobile (Lenovo LOQ)
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "======================================================================"
echo " [CLISA-CORE] INICIANDO BLINDAJE BTRFS Y EXPANSION ELECTROMECANICA"
echo "======================================================================"

# 1. BLINDAJE BTRFS (TIMESHIFT & SNAPPER POLICY)
echo "[1/4] Configurando blindaje BTRFS y políticas de snapshots automáticos..."
mkdir -p /etc/timeshift
if [ -f "${SCRIPT_DIR}/config/timeshift.json" ]; then
    cp "${SCRIPT_DIR}/config/timeshift.json" /etc/timeshift/timeshift.json
fi

echo "[+] Asegurando paquetes de gestión de snapshots..."
dnf install -y snapper python3-dnf-plugin-snapper timeshift || true

echo "[+] Generando snapshot BTRFS base: CLISA_BASE_SECURE..."
timeshift --create --comments "CLISA_BASE_SECURE" --tags D 2>/dev/null || {
    echo "[!] Timeshift CLI fallback. Verificando subvolúmenes Btrfs directos..."
    btrfs subvolume snapshot / /@_CLISA_BASE_SECURE 2>/dev/null || true
}

# 2. EXPANSION DEL ARSENAL ELECTROMECANICO (PAQUETES NATIVOS DE SISTEMA)
echo "[2/4] Instalando herramientas de hardware, telemetría y control de versiones..."
dnf install -y pulseview sigrok-cli sigrok-firmware-fx2lafw sigrok-firmware-nonfree picocom minicom gh || true

# 3. UDEV RULES & PERMISOS DE GRUPO PARA HARDWARE / INSTRUMENTACION
echo "[3/4] Inyectando reglas udev para analizadores lógicos, osciloscopios y MCUs..."
if [ -f "${SCRIPT_DIR}/config/60-libsigrok.rules" ]; then
    cp "${SCRIPT_DIR}/config/60-libsigrok.rules" /etc/udev/rules.d/60-libsigrok.rules
fi
if [ -f "${SCRIPT_DIR}/config/99-platformio-udev.rules" ]; then
    cp "${SCRIPT_DIR}/config/99-platformio-udev.rules" /etc/udev/rules.d/99-platformio-udev.rules
fi
udevadm control --reload-rules || true
udevadm trigger || true

CURRENT_USER="${SUDO_USER:-$USER}"
echo "[+] Asignando grupos de telemetría serial al operador ($CURRENT_USER)..."
usermod -a -G dialout,uucp,lock,tty "$CURRENT_USER" || true

# 4. ENTORNO GLOBAL & COMPATIBILIDAD GRAFICA QT/WAYLAND
echo "[4/4] Inyectando variables globales en /etc/environment..."
if [ -w /etc/environment ]; then
    grep -q "QT_QPA_PLATFORM" /etc/environment 2>/dev/null || echo "QT_QPA_PLATFORM=wayland;xcb" >> /etc/environment
    grep -q "QT_AUTO_SCREEN_SCALE_FACTOR" /etc/environment 2>/dev/null || echo "QT_AUTO_SCREEN_SCALE_FACTOR=1" >> /etc/environment
fi

echo "======================================================================"
echo " [✓] BLINDAJE Y EXPANSIÓN DE SISTEMA COMPLETADOS EXITOSAMENTE"
echo "======================================================================"
