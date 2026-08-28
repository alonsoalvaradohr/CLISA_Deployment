#!/usr/bin/env bash
# ==============================================================================
# CLISA DRACONIAN PURGE & SYSTEM DISTRO-SYNC (ROOT SYNC SCRIPT)
# ==============================================================================
set -euo pipefail

echo "[+] 1. Purgando caché DNF y PackageKit..."
dnf clean all
rm -rf /var/cache/dnf/* /var/cache/PackageKit/*

echo "[+] 2. Forzando sincronización draconiana de distribución (DNF Distro-Sync)..."
dnf distro-sync --refresh --allowerasing -y

echo "[+] 3. Reparando y actualizando Flatpaks (System & User)..."
flatpak repair || true
flatpak update --system -y || true
flatpak update --user -y || true
flatpak uninstall --unused -y || true

echo "[+] 4. Verificación de salida..."
dnf check-update || true
flatpak list
echo "[✓] Sincronización absoluta completada."
