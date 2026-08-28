# PROYECTO CLISA — MANIFIESTO 01: VISIÓN, OBJETIVO Y DIRECTIVAS SUPREMAS
**Versión:** 1.0.0 (Fase 0 - Arquitectura Fundacional)  
**Entorno Operativo:** Nobara Linux 44 // Lenovo LOQ 16APH8 (AMD Ryzen 7 7840HS / NVIDIA RTX 4060 Mobile)  
**Autoridad:** Arquitectura de Sistemas Autónomos & CLISA-AGENT Nivel 4

---

## 1. MISIÓN Y VISIÓN SUPREMA (THE GOAL)
El **Proyecto CLISA (Core Linux Intelligent System Architecture)** tiene como objetivo primordial transformar la estación de trabajo en una máquina de ingeniería paramétrica, hermética, de latencia cognitiva cero y de rendimiento determinista.

El ecosistema está concebido específicamente para **Ingeniería Electromecánica, I+D (R&D), Simulación Multifísica, Desarrollo de Firmware y Documentación Científica (LaTeX)**. Todo el entorno será orquestado, auditado y optimizado en tiempo real por agentes autónomos inteligentes (CLISA-AGENTS) vía Antigravity CLI.

---

## 2. DIRECTIVAS INMUTABLES (AXIOMAS DE SEGURIDAD)

> [!CAUTION]
> **DIRECTIVA 01 — AISLAMIENTO ABSOLUTO DEL DUAL-BOOT (WINDOWS):**
> - La unidad física secundaria `A-DATA LEGEND 900 PRO` (`/dev/nvme1n1`) y todas sus particiones NTFS/ESP (`nvme1n1p1` a `nvme1n1p5`) son **estrictamente de solo lectura / intocables**.
> - Ningún agente o script automatizado tiene autorización para montar, formatear, escribir o reconfigurar la tabla de particiones o el bootloader de dicha unidad.

> [!IMPORTANT]
> **DIRECTIVA 02 — REGLA COGNITIVA 90 / 5 / 5:**
> - **90% del Tiempo/Recursos:** Trabajo de ingeniería pura, diseño CAD, compilación de firmware, simulación y generación de valor.
> - **5% del Tiempo/Recursos:** Orquestación y gobernanza de agentes en segundo plano.
> - **5% del Tiempo/Recursos:** Mantenimiento proactivo, purga de cachés e higiene del sistema.

> [!NOTE]
> **DIRECTIVA 03 — DETERMINISMO Y CERO LATENCIA:**
> - Las configuraciones deben ser declarativas, reproducibles y versionadas.
> - Se prioriza la ejecución de utilidades ligeras en CLI, wrappers parametrizados y gestores de ventanas tipo *tiling* para suprimir la fricción entre el pensamiento y la ejecución.

---

## 3. HITOS DE DESARROLLO (ROADMAP CLISA)

```mermaid
graph LR
    F0["Fase 0: Auditoría & Fundamentos"] --> F1["Fase 1: Tiling & Minimalismo UI"]
    F1 --> F2["Fase 2: Arsenal Electromecánico"]
    F2 --> F3["Fase 3: IOMMU & Passthrough GPU"]
    F3 --> F4["Fase 4: Agentes Residentes CLISA"]
```

1. **Hito 0 (Fase Actual):** Reconocimiento integral de hardware, telemetría basal y despliegue del repositorio de control `CLISA_Deployment`.
2. **Hito 1 (Entorno Tiling Paramétrico):** Transición o convivencia optimizada hacia un entorno de ventanas tipo mosaico (`i3wm` sobre X11 o `Sway`/`Hyprland` sobre Wayland), integrando barras de estado con telemetría en vivo.
3. **Hito 2 (Arsenal de Ingeniería Completo):** Aprovisionamiento automatizado de herramientas CAD (FreeCAD/OpenSCAD), EDA (KiCad), computación científica (Octave/Jupyter/SymPy), toolchains de microcontroladores (`arduino-cli`, GCC-ARM) y librerías completas de LaTeX (`circuitikz`, `karnaugh-map`).
4. **Hito 3 (Orquestación IOMMU Dinámica):** Gobernanza del paso de la GPU NVIDIA RTX 4060 Mobile entre `vfio-pci` (para máquinas virtuales KVM de simulación/Windows) y controladores nativos `nvidia` según la carga demandada.
5. **Hito 4 (Automatización Residente de Agentes):** Despliegue de demonios autónomos CLISA para monitoreo de batería, temperatura, higiene de paquetes Flatpak/DNF y balance de subvolúmenes Btrfs.
