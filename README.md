# CLISA Deployment & Intelligent Infrastructure Suite

[![CLISA Architecture](https://img.shields.io/badge/Architecture-Nobara%2044%20|%20Zen%204-blue.svg)](docs/00_STATE_OF_THE_ART.md)
[![Git Governance](https://img.shields.io/badge/Governance-ISO--Grade%20Atomic-green.svg)](GIT_GOVERNANCE_AUDIT.md)
[![Hardware Inviolability](https://img.shields.io/badge/Windows%20Dual--Boot-Sealed%20%26%20Isolated-red.svg)](IOMMU_GROUP_AUDIT.md)
[![3 Lifelines](https://img.shields.io/badge/Lifelines-Stable%20|%20Test%20|%20Deployed-orange.svg)](README.md#3-arquitectura-de-versiones-3-l%C3%ADneas-de-vida)

Bienvenido al repositorio maestro de gobernanza, configuración y despliegue para la estación de trabajo y laboratorio de ingeniería **CLISA (Core Linux Intelligent System Architecture)**.

Este ecosistema transforma una laptop de alto rendimiento (**Lenovo LOQ 16APH8** // AMD Ryzen 7 7840HS // NVIDIA RTX 4060 // 16GB DDR5) en una estación de ingeniería electromecánica, simulación multifísica y desarrollo robótico para los proyectos **DanyBot** y **CMU**.

---

## 🗺️ ÍNDICE MAESTRO DE NAVEGACIÓN (TABLE OF CONTENTS)

### 📚 1. Compendio Documental "Zero to Hero"
* [**`docs/00_STATE_OF_THE_ART.md`**](docs/00_STATE_OF_THE_ART.md): Génesis del proyecto, justificación de la arquitectura (Nobara, Btrfs, Wayland, Sway, perfiles ACPI/PD).
* [**`docs/01_SYSTEM_ARCHITECTURE.md`**](docs/01_SYSTEM_ARCHITECTURE.md): Topología integral del sistema, diagramas de flujo Mermaid (Hardware, Btrfs, KVM/IOMMU, Scripts, HIL).
* [**`docs/02_DEV_BACKLOG.md`**](docs/02_DEV_BACKLOG.md): Hoja de ruta priorizada, backlog de desarrollo, tareas de ingeniería y mitigación de deuda técnica.
* [**`docs/03_AGENT_SWARM_PROTOCOLS.md`**](docs/03_AGENT_SWARM_PROTOCOLS.md): Protocolos del enjambre de agentes autónomos, bucle O-I-P-E-V-R y consenso tripartito.
* [**`01_Goal_Objective.md`**](01_Goal_Objective.md): Visión fundacional, directivas supremas y regla cognitiva 90/5/5.
* [**`02_Hardware_Intelligence.md`**](02_Hardware_Intelligence.md): Inventario exhaustivo de hardware, sensores térmicos y particionamiento.
* [**`03_Software_Intelligence.md`**](03_Software_Intelligence.md): Inventario de software, toolchains de desarrollo y análisis de brechas (Gap Analysis).
* [**`04_Agent_Orchestration.md`**](04_Agent_Orchestration.md): Esquema de agentes residentes y contratos de telemetría.

### ⚙️ 2. Arsenal de Scripts Operativos (`scripts/`)
* [`scripts/clisa_sys_foundation.sh`](scripts/clisa_sys_foundation.sh): Cimentación del sistema, afinación de sysctl, actualización DNF y reglas udev.
* [`scripts/clisa_phase6_shield.sh`](scripts/clisa_phase6_shield.sh): Blindaje Btrfs, políticas de snapshots Timeshift/Snapper y herramientas electromecánicas.
* [`scripts/clisa_thermal_governance.sh`](scripts/clisa_thermal_governance.sh): Gobernanza térmica para AMD Zen 4, supresión de throttling y telemetría en vivo.
* [`scripts/clisa_power_governor.sh`](scripts/clisa_power_governor.sh): Selector dinámico de perfil de energía (AC High Power vs USB-C 140W PD vs Batería).
* [`scripts/clisa_matlab_silent_deploy.sh`](scripts/clisa_matlab_silent_deploy.sh): Instalador desatendido y smoke test automatizado para MATLAB.
* [`scripts/clisa_draconian_sync.sh`](scripts/clisa_draconian_sync.sh): Purga absoluta de cachés, sincronización DNF y reparación de Flatpaks.

### 🔧 3. Archivos de Configuración del Sistema (`config/`)
* [`config/99-clisa-cpu.conf`](config/99-clisa-cpu.conf): Parámetros de gobernador y EPP para AMD P-State.
* [`config/99-clisa-mem.conf`](config/99-clisa-mem.conf): Afinado de memoria virtual, ZRAM y presión sobre caché VFS.
* [`config/99-clisa-network.conf`](config/99-clisa-network.conf): Fortalecimiento TCP/IP (BBR, mitigación SYN Flood, Fast Open).
* [`config/60-libsigrok.rules`](config/60-libsigrok.rules): Reglas udev para analizadores lógicos (Saleae, FX2, Agilent, Brymen).
* [`config/99-platformio-udev.rules`](config/99-platformio-udev.rules): Reglas udev para desarrollo embebido (FTDI, CH34x, STM32, Pico, Teensy).
* [`config/10-looking-glass.conf`](config/10-looking-glass.conf): Regla de memoria compartida IVSHMEM (`/dev/shm/looking-glass`).
* [`config/timeshift.json`](config/timeshift.json): Política de snapshots diarios y de arranque en Btrfs.
* [`config/clisa_aliases.sh`](config/clisa_aliases.sh): Aceleradores de terminal, atajos de navegación y telemetría `clisa-status`.
* [`config/sway/config`](config/sway/config): Configuración del gestor de ventanas tiling Sway sobre Wayland.
* [`config/waybar/config`](config/waybar/config): Barra de estado Waybar con telemetría de CPU, RAM, térmica y batería.
* [`config/alacritty/alacritty.toml`](config/alacritty/alacritty.toml): Emulador de terminal con paleta Gruvbox de alto contraste.

### 🛡️ 4. Auditorías de Sistema y Bitácoras Vivas
* [**`COMMAND_EXECUTION_AUDIT.md`**](COMMAND_EXECUTION_AUDIT.md): Historial cronológico de todos los comandos ejecutados en el sistema.
* [**`IOMMU_GROUP_AUDIT.md`**](IOMMU_GROUP_AUDIT.md): Topología completa de grupos IOMMU, PCIe bridges y aislamiento de GPU.
* [**`GIT_GOVERNANCE_AUDIT.md`**](GIT_GOVERNANCE_AUDIT.md): Bitácora formal de control de versiones, consenso de agentes y estado de sincronización remota.
* [**`.agents/`**](.agents/): Definiciones de subagentes ([`cerbero.md`](.agents/cerbero.md), [`ontologist.md`](.agents/ontologist.md), [`architect.md`](.agents/architect.md), [`surgeon.md`](.agents/surgeon.md)).

---

## 🏛️ 3. ARQUITECTURA DE VERSIONES (3 LÍNEAS DE VIDA)

| Línea de Vida | Rama / Tag | Propósito | Criterio de Estabilidad |
| :--- | :--- | :--- | :--- |
| **Stable** | `main` | Entorno de producción verificado y operativo. | Tests de hardware y scripts validados al 100%. |
| **Test** | `develop` | Integración continua y release candidates (`vX.Y.Z-rc.N`). | Validación de nuevas configuraciones y scripts. |
| **Deployed** | `v1.0.0` (Tags) | Instantáneas inmutables de producción para rollback exacto. | Firmado y documentado en bitácora de gobernanza. |

---

## ⚡ GUÍA OPERATIVA DE ACTUALIZACIÓN (ONE-COMMAND RUNBOOK)

Para actualizar o sincronizar la estación CLISA de manera determinista:

```bash
# Sincronización completa de producción (Stable / Deployed)
git checkout main && git pull --ff-only origin main

# Sincronización para banco de pruebas / desarrollo (Test)
git checkout develop && git pull --ff-only origin develop
```

---

## 🚀 GUÍA DE INICIO RÁPIDO PARA NUEVOS OPERADORES ("ZERO TO HERO")

1. **Cargar los aceleradores de terminal:**
   ```bash
   source /home/alonso/Documents/CLISA_Deployment/config/clisa_aliases.sh
   ```
2. **Inspeccionar la salud de la estación de trabajo:**
   ```bash
   clisa-status
   ```
3. **Verificar el aislamiento del disco dual-boot Windows:**
   ```bash
   clisa-nvme-check
   ```
4. **Aplicar la política térmica y de energía actual:**
   ```bash
   clisa-power
   ```
