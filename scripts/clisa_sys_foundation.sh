#!/usr/bin/env bash
set -euo pipefail

echo "======================================================="
echo "   CLISA SYSTEM FOUNDATION & OPTIMIZATION (AUDITED RUN)"
echo "======================================================="

# 1. SYSCTL OPTIMIZATIONS (MEMORY + NETWORK)
echo "[+] Inyectando perfiles sysctl auditados en /etc/sysctl.d/ ..."
cp /home/alonso/Documents/CLISA_Deployment/config/99-clisa-mem.conf /etc/sysctl.d/99-clisa-mem.conf
cp /home/alonso/Documents/CLISA_Deployment/config/99-clisa-network.conf /etc/sysctl.d/99-clisa-network.conf
sysctl --system

# 2. CPU GOVERNOR & AMD P-STATE EPP TUNING
echo "[+] Ajustando AMD P-State EPP a performance para suprimir latencia..."
for epp in /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference; do
    [ -f "$epp" ] && echo "performance" > "$epp" 2>/dev/null || true
done
for gov in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    [ -f "$gov" ] && echo "performance" > "$gov" 2>/dev/null || true
done

# 3. BTRFS METADATA BALANCE
echo "[+] Ejecutando rebalanceo suave de metadatos BTRFS en / ..."
btrfs balance start -musage=10 / 2>/dev/null || btrfs balance start -m / 2>/dev/null || true

# 4. CORE SYSTEM DNF UPGRADE & CLEANUP
echo "[+] Sincronizando repositorios y actualizando core OS..."
dnf upgrade --refresh -y
dnf autoremove -y
dnf clean all

# 5. TILING & EMBEDDED SYSTEM PACKAGES
echo "[+] Instalando paquetería de sistema para Tiling UI y Firmware..."
dnf install -y sway waybar rofi-wayland alacritty wl-clipboard qt5-qtwayland qt6-qtgui openocd arm-none-eabi-gcc-cs arm-none-eabi-newlib texlive-scheme-basic || true

# 6. FIRMWARE ALIGNMENT
echo "[+] Verificando actualizaciones de firmware..."
fwupdmgr get-updates || true

echo "[✓] Cimentación de sistema completada exitosamente."

# 7. UDEV RULES & USER GROUPS (PLATFORMIO / EMBEDDED)
echo "[+] Inyectando reglas udev de PlatformIO y grupos de usuario..."
cp /home/alonso/Documents/CLISA_Deployment/config/99-platformio-udev.rules /etc/udev/rules.d/99-platformio-udev.rules
udevadm control --reload-rules || true
udevadm trigger || true
usermod -a -G dialout,tty alonso || true
