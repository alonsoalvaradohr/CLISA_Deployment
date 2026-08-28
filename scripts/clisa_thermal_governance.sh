#!/usr/bin/env bash
# ==============================================================================
# CLISA THERMAL & POWER GOVERNANCE ORCHESTRATOR (AMD ZEN 4 7840HS / LENOVO LOQ)
# ==============================================================================
set -euo pipefail

echo "======================================================================"
echo " [CLISA-CORE] APLICANDO GOBERNANZA TÉRMICA Y POLÍTICA DE POTENCIA"
echo "======================================================================"

# 1. ACPI PLATFORM PROFILE (LENOVO PERFORMANCE MODE)
if [ -w /sys/firmware/acpi/platform_profile ]; then
    echo "[+] Estableciendo perfil ACPI Lenovo en 'performance'..."
    echo "performance" > /sys/firmware/acpi/platform_profile || true
fi

# 2. CPU SCALING GOVERNOR & AMD P-STATE EPP (ALL CORES)
echo "[+] Fijando gobernador 'performance' y EPP 'performance' en todos los núcleos..."
for gov in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    [ -w "$gov" ] && echo "performance" > "$gov" 2>/dev/null || true
done

for epp in /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference; do
    [ -w "$epp" ] && echo "performance" > "$epp" 2>/dev/null || true
done

# 3. SUPRESIÓN DEL PISO DE FRECUENCIA ANÓMALO (THROTTLING PREVENTION)
echo "[+] Verificando umbrales mínimos de frecuencia de reloj..."
for min_f in /sys/devices/system/cpu/cpu*/cpufreq/scaling_min_freq; do
    [ -w "$min_f" ] && echo "1100000" > "$min_f" 2>/dev/null || true
done

# 4. TELEMETRÍA DE HARDWARE EN TIEMPO REAL
echo "----------------------------------------------------------------------"
echo " TELEMETRÍA DE POTENCIA Y SALUD TÉRMICA ACTIVA:"
echo "----------------------------------------------------------------------"
CURR_PROFILE=$(cat /sys/firmware/acpi/platform_profile 2>/dev/null || echo "N/A")
CURR_GOV=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null || echo "N/A")
CURR_EPP=$(cat /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference 2>/dev/null || echo "N/A")
CURR_FREQ=$(awk '{printf "%.1f MHz", $1/1000}' /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq 2>/dev/null || echo "N/A")
TCTL_TEMP=$(sensors 2>/dev/null | grep -A 1 "k10temp" | grep "Tctl" | awk '{print $2}' || echo "N/A")

echo " * Perfil ACPI Platform: $CURR_PROFILE"
echo " * Gobernador CPU:       $CURR_GOV"
echo " * AMD P-State EPP:      $CURR_EPP"
echo " * Frecuencia Core 0:    $CURR_FREQ"
echo " * Temperatura CPU Tctl: $TCTL_TEMP"
echo "======================================================================"
echo " [✓] GOBERNANZA TÉRMICA CONSOLIDADA (ANTI-THROTTLING ACTIVO)"
echo "======================================================================"
