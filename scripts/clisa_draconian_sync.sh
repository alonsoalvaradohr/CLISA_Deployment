#!/usr/bin/env bash
# ==============================================================================
# CLISA DRACONIAN PURGE & SYSTEM DISTRO-SYNC
# Target: Nobara Linux Base Hygiene, Cache Purge and Flatpak Alignment
# ==============================================================================
set -euo pipefail

echo "======================================================================"
echo " [CLISA-HYGIENE] INICIANDO PURGA Y SINCRONIZACIÓN DRACONIANA DE SISTEMA"
echo "======================================================================"

echo "[1/4] Purgando cachés volátiles de DNF y PackageKit..."
dnf clean all
rm -rf /var/cache/dnf/* /var/cache/PackageKit/* 2>/dev/null || true

echo "[2/4] Ejecutando sincronización de distribución (DNF Distro-Sync)..."
dnf distro-sync --refresh --allowerasing -y

echo "[3/4] Reparando y actualizando Flatpaks (System & User)..."
flatpak repair || true
flatpak update --system -y || true
flatpak update --user -y || true
flatpak uninstall --unused -y || true

echo "[4/4] Verificando sanidad de paquetes finales..."
dnf check-update || true

echo "======================================================================"
echo " [✓] SINCRONIZACIÓN Y PURGA DRACONIANA COMPLETADAS EXITOSAMENTE"
echo "======================================================================"
