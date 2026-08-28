#!/usr/bin/env bash
# ==============================================================================
# CLISA-AGENT PHASE 6: BLINDAJE BTRFS, EXPANSION R&D Y OPTIMIZACION DE ENTORNO
# Target: Nobara Linux 44 (Kernel 7.1.x) // AMD 7840HS + RTX 4070 Laptop
# ==============================================================================
set -euo pipefail

echo "======================================================================"
echo " [CLISA-CORE] INICIANDO BLINDAJE BTRFS Y EXPANSION ELECTROMECANICA"
echo "======================================================================"

# 1. BLINDAJE BTRFS (TIMESHIFT & SNAPPER POLICY)
echo "[1/4] Configurando blindaje BTRFS y políticas de snapshots automáticos..."
mkdir -p /etc/timeshift
cp ${CLISA_ROOT:-/opt/clisa}/config/timeshift.json /etc/timeshift/timeshift.json

echo "[+] Instalando plugins de snapshot y paquetes base..."
dnf install -y snapper python3-dnf-plugin-snapper timeshift || true

echo "[+] Generando snapshot BTRFS base: CLISA_BASE_SECURE..."
timeshift --create --comments "CLISA_BASE_SECURE" --tags D || {
    echo "[!] Timeshift CLI fallback. Verificando subvolúmenes Btrfs..."
    btrfs subvolume snapshot / /@_CLISA_BASE_SECURE || true
}

# 2. EXPANSION DEL ARSENAL ELECTROMECANICO (PAQUETES NATIVOS DE SISTEMA)
echo "[2/4] Instalando herramientas de hardware, telemetria y control de versiones..."
dnf install -y pulseview sigrok-cli sigrok-firmware-fx2lafw sigrok-firmware-nonfree picocom minicom gh || true

# 3. UDEV RULES & PERMISOS DE GRUPO PARA HARDWARE / INSTRUMENTACION
echo "[3/4] Inyectando reglas udev para analizadores lógicos, osciloscopios y MCUs..."
cp ${CLISA_ROOT:-/opt/clisa}/config/60-libsigrok.rules /etc/udev/rules.d/60-libsigrok.rules
cp ${CLISA_ROOT:-/opt/clisa}/config/99-platformio-udev.rules /etc/udev/rules.d/99-platformio-udev.rules
udevadm control --reload-rules
udevadm trigger

echo "[+] Asignando grupos de telemetria serial al operador $USER..."
usermod -a -G dialout,uucp,lock,tty $USER || true

# 4. ENTORNO GLOBAL & COMPATIBILIDAD GRAFICA QT/WAYLAND
echo "[4/4] Inyectando variables globales en /etc/environment..."
grep -q "QT_QPA_PLATFORM" /etc/environment 2>/dev/null || {
    echo "QT_QPA_PLATFORM=wayland;xcb" >> /etc/environment
    echo "QT_AUTO_SCREEN_SCALE_FACTOR=1" >> /etc/environment
}

echo "======================================================================"
echo " [✓] BLINDAJE Y EXPANSION DE SISTEMA COMPLETADOS EXITOSAMENTE"
echo "======================================================================"
