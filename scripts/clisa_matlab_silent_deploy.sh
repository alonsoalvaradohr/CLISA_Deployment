#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2024-2026 Alonso Alvarado Hernández <alonsoalvaradohr>
# ==============================================================================
# CLISA AUTOMATED SILENT MATLAB INSTALLER & SMOKE TEST ORCHESTRATOR
# Non-Interactive deployment for Engineering & Simulation workloads
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INSTALLER_SOURCE="${1:-}"

if [ -z "$INSTALLER_SOURCE" ]; then
    echo "[-] Error: Se requiere la ruta al instalador de MATLAB (Directorio, ISO o Binario install)."
    echo "    Uso: sudo $0 /ruta/al/instalador_o_iso"
    exit 1
fi

TEMP_MOUNT=""
INSTALL_DIR="$INSTALLER_SOURCE"

if [ -f "$INSTALLER_SOURCE" ] && [[ "$INSTALLER_SOURCE" =~ \.iso$ ]]; then
    echo "[+] Detectada imagen ISO. Montando temporalmente en /mnt/matlab_iso..."
    TEMP_MOUNT="/mnt/matlab_iso"
    mkdir -p "$TEMP_MOUNT"
    mount -o loop,ro "$INSTALLER_SOURCE" "$TEMP_MOUNT"
    INSTALL_DIR="$TEMP_MOUNT"
fi

if [ ! -f "$INSTALL_DIR/install" ]; then
    echo "[-] Error: No se encontró el binario 'install' en $INSTALL_DIR"
    [ -n "$TEMP_MOUNT" ] && umount "$TEMP_MOUNT" || true
    exit 1
fi

INPUT_FILE="${SCRIPT_DIR}/config/installer_input.txt"
if [ ! -f "$INPUT_FILE" ]; then
    echo "[-] Error: No se encontró el archivo de configuración en $INPUT_FILE"
    [ -n "$TEMP_MOUNT" ] && umount "$TEMP_MOUNT" || true
    exit 1
fi

echo "[+] Ejecutando instalación silenciosa de MATLAB desde $INSTALL_DIR..."
"$INSTALL_DIR/install" -mode silent -inputFile "$INPUT_FILE"

if [ -n "$TEMP_MOUNT" ]; then
    echo "[+] Desmontando imagen ISO temporal..."
    umount "$TEMP_MOUNT" || true
    rmdir "$TEMP_MOUNT" || true
fi

echo "[+] Configurando enlaces simbólicos globales..."
mkdir -p /usr/local/bin
MATLAB_BIN=$(find /usr/local/MATLAB -name "matlab" -type f -perm /111 2>/dev/null | head -n 1 || true)
if [ -n "$MATLAB_BIN" ]; then
    ln -sf "$MATLAB_BIN" /usr/local/bin/matlab
    if [ -d "${HOME}/.local/bin" ]; then
        ln -sf "$MATLAB_BIN" "${HOME}/.local/bin/matlab"
    fi
fi

echo "[+] Ejecutando CLI Smoke Test..."
if command -v matlab >/dev/null 2>&1; then
    matlab -nodisplay -nosplash -nodesktop -r "disp('MATLAB CORE OPERATIVO'); exit;"
fi
echo "[✓] Despliegue de MATLAB finalizado exitosamente."
