# PROYECTO CLISA — MANIFIESTO 03: ARSENAL DE SOFTWARE, DEPENDENCIAS Y GAP ANALYSIS
**Sistema Base:** Nobara Linux 44 (KDE Plasma Desktop Edition / Base Fedora 44)  
**Núcleo:** Linux Kernel `7.1.3-200.nobara.fc44.x86_64`  
**Servidor Gráfico:** Wayland (`kwin_wayland` + `Xwayland 24.1.11`)

---

## 1. INVENTARIO DEL SOFTWARE ACTUALMENTE INSTALADO

### 1.1. Desarrollo y Toolchains
* **Python Runtime:** `Python 3.14.6` con librerías base instaladas (`Cython 3.2.4`, `cairocffi`, `CairoSVG`, `cryptography`, `dasbus`, `click`, etc.).
* **Entornos de Desarrollo (IDE):**
  * **VS Code:** `v1.129.1` instalado y accesible globalmente (`code`).
* **Documentación Científica (LaTeX Stack):**
  * **TeX Engine:** `TeX Live 2026` / `pdfTeX 3.141592653-2.6-1.40.29`.
  * **Editor LaTeX:** `TeXstudio` instalado.
* **Capas de Compatibilidad y Windows Apps:**
  * **Wine:** `wine-11.13 (Staging)` a nivel de sistema.
  * **Bottles:** `v66.7` (Flatpak) con runtimes actualizados (`Wine Gecko`, `Wine Mono`, `Freedesktop Platform 25.08 / GL 26.1.6`).
* **Virtualización y Contenedores:**
  * **QEMU / KVM:** `QEMU emulator version 10.2.2` (`qemu-10.2.2-1.fc44`).
  * **Libvirt:** Componentes y módulos kernel `kvm_amd`, `vfio_pci_core` e `irqbypass` operativos.
  * **Contenedores:** **Podman 5.8.4** (OCI engine rootless instalado).
* **Audio & Multimedia de Baja Latencia:**
  * **PipeWire:** `v1.6.8` con soporte ALSA/PulseAudio.

---

## 2. ANÁLISIS DE BRECHA (GAP ANALYSIS PARA INGENIERÍA ELECTROMECÁNICA)

Para materializar el **Goal Supremo** de una estación de trabajo de alta ingeniería, se identifican los siguientes paquetes faltantes por desplegar:

| Categoría | Software Requerido | Estado Actual | Solución Recomendada |
| :--- | :--- | :--- | :--- |
| **CAD Paramétrico 3D** | FreeCAD / OpenSCAD / SolveSpace | ❌ No instalado | Instalar vía Flatpak o DNF (`freecad`, `openscad`). |
| **Diseño Electrónico (EDA)** | KiCad 8.x / 9.x | ❌ No instalado | Desplegar suite completa KiCad (Esquemáticos + PCB + 3D Models). |
| **Matemáticas / Simulación** | GNU Octave / Jupyter Lab / NumPy / SymPy | ❌ No instalado | Crear `venv` de Python para ingeniería científica e instalar GNU Octave. |
| **Firmware & Embebidos** | `arduino-cli`, `avrdude`, `picotool`, OpenOCD | ❌ No instalado | Instalar `arduino-cli` en `~/.local/bin` y toolchain GCC ARM Embedded. |
| **Paquetes LaTeX Clave** | `circuitikz.sty`, `karnaugh-map.sty` | ⚠️ Faltan macros | Instalar colección `texlive-scheme-full` o mediante `tlmgr`. |
| **Entorno Tiling UI** | `i3wm` / `Sway` / `Hyprland` + Waybar | ⚠️ KDE Plasma activo | Configurar sesión tiling ligera para trabajo intensivo con hotkeys. |

---

## 3. ESTADO DE LOS RUNTIMES FLATPAK & GESTOR DE PAQUETES
* **Flatpak Sandbox:** Totalmente actualizado. Los runtimes gráficos Mesa extra y GNOME Platform 49 están sincronizados y limpios de versiones obsoletas.
* **DNF / RPM Base:** El core del sistema requiere actualización mediante `sudo dnf upgrade --refresh -y` en sesión autenticada con contraseña.
