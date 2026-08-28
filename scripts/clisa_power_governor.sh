#!/usr/bin/env bash
# ==============================================================================
# CLISA DYNAMIC POWER GOVERNOR (USB-C PD 140W vs HIGH POWER AC SUPPLY)
# Target: AMD Ryzen 7 7840HS / Lenovo LOQ 16
# ==============================================================================
set -euo pipefail

get_power_source() {
    local acad_online="0"
    local usbc_online="0"

    if [ -f /sys/class/power_supply/ACAD/online ]; then
        acad_online=$(cat /sys/class/power_supply/ACAD/online)
    fi

    if [ -f /sys/class/power_supply/ucsi-source-psy-USBC000:001/online ]; then
        usbc_online=$(cat /sys/class/power_supply/ucsi-source-psy-USBC000:001/online)
    fi

    if [ "$acad_online" = "1" ]; then
        echo "AC_HIGH_POWER"
    elif [ "$usbc_online" = "1" ]; then
        echo "USBC_PD_140W"
    else
        echo "BATTERY"
    fi
}

apply_profile() {
    local mode="$1"
    echo "[CLISA Power Governor] Modo detectado: $mode"

    case "$mode" in
        "AC_HIGH_POWER")
            echo "[+] Aplicando perfil ALTO RENDIMIENTO (AC Supply)..."
            if [ -w /sys/firmware/acpi/platform_profile ]; then
                echo "performance" > /sys/firmware/acpi/platform_profile 2>/dev/null || true
            fi
            for g in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
                [ -w "$g" ] && echo "performance" > "$g" 2>/dev/null || true
            done
            for e in /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference; do
                [ -w "$e" ] && echo "performance" > "$e" 2>/dev/null || true
            done
            for m in /sys/devices/system/cpu/cpu*/cpufreq/scaling_min_freq; do
                [ -w "$m" ] && echo "1100000" > "$m" 2>/dev/null || true
            done
            ;;
        "USBC_PD_140W"|"BATTERY")
            echo "[+] Aplicando perfil BALANCEADO / PROTECCIÓN TÉRMICA (USB-C PD / Batería)..."
            if [ -w /sys/firmware/acpi/platform_profile ]; then
                echo "balanced" > /sys/firmware/acpi/platform_profile 2>/dev/null || true
            fi
            for g in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
                [ -w "$g" ] && echo "powersave" > "$g" 2>/dev/null || true
            done
            for e in /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference; do
                [ -w "$e" ] && echo "balance_performance" > "$e" 2>/dev/null || true
            done
            for m in /sys/devices/system/cpu/cpu*/cpufreq/scaling_min_freq; do
                [ -w "$m" ] && echo "800000" > "$m" 2>/dev/null || true
            done
            ;;
    esac
}

CURRENT_SOURCE=$(get_power_source)
apply_profile "$CURRENT_SOURCE"
