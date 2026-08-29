# ROADMAP Y DEV BACKLOG (CLISA FASE 22)
**Documento:** `docs/02_DEV_BACKLOG.md`  
**Estado:** Activo y Priorizado (Fiscalización Empírica Cerbero)  
**Métricas de Calidad:** ISO-Grade / Determinista / Cero Deuda Técnica / Cero Alucinaciones

---

## 1. BACKLOG PRIORIZADO (SPRINT ROADMAP)

### Épica 0: Saneamiento Base, Recuperación Web y Orquestación Gráfica (FASE 21 - 22)
- [x] **BL-001 [Clean Slate]:** Actualización exhaustiva y desatendida del sistema base (DNF/Nobara 44), Flatpaks (Bottles, FreeCAD, KiCad, Octave) y purga de huérfanos.
- [x] **BL-002 [Tiling WM]:** Despliegue de suite Sway + Waybar + Alacritty bajo Wayland con reglas IPC paramétricas de asignación de 5 espacios de trabajo (`DEV`, `CAD`, `MANUF`, `DOC`, `SYS`).
- [x] **BL-003 [Window Ergonomics]:** Inyección de reglas de flotación inteligente para modales de Autodesk Fusion 360 y figuras/scopes de MATLAB R2024b, preservando mosaico estricto en IDEs y CLI.
- [x] **BL-004 [P0 - Firefox Recovery]:** Diagnóstico de causa raíz (SIGSEGV en `libxul`/`libwayland-client`), purga de cachés de sesión corruptas, remoción de variable redundante `MOZ_ENABLE_WAYLAND=1` y validación empírica de supervivencia de PID > 20s sin Crash Reporter.
- [x] **BL-005 [P0 - Display Manager Autologin]:** Configuración de sesión por defecto desatendida (`sway`) en AccountsService D-Bus, `~/.dmrc` y archivo declarativo `config/sddm.conf.d/autologin.conf`.
- [x] **BL-006 [P0 - Notification Ergonomics]:** Despliegue de configuración `mako` con auto-descarte estricto (`default-timeout=4000` ms) y recarga de demonio en memoria (`makoctl reload`).
- [x] **BL-007 [P0 - Cerbero Auditor]:** Instanciación de `.agents/cerbero.md` como perro de traba para fiscalización forense obligatoria.

### Épica 1: Expansión del Arsenal Electromecánico (CAD / EDA / Simulación)
- [x] **BL-101 [EDA]:** Despliegue de KiCad 10.x con soporte de librerías y esquemáticos.
- [ ] **BL-102 [CAD]:** Creación de plantillas paramétricas en FreeCAD / OpenSCAD para prototipado rápido de piezas robóticas DanyBot.
- [x] **BL-103 [LaTeX]:** Integración de macros avanzadas `circuitikz` y `karnaugh-map` en el árbol de TeX Live local.
- [ ] **BL-104 [ROS2]:** Aprovisionamiento de contenedor rootless Podman con ROS 2 Jazzy Jalisco / Humble para simulación de odometría y SLAM en DanyBot.

### Épica 2: Virtualización KVM y GPU Passthrough Dinámico
- [ ] **BL-201 [IOMMU]:** Script automatizado de conmutación en caliente (*hot-unbinding*) de la NVIDIA RTX 4060 entre `vfio-pci` y `nvidia-current`.
- [ ] **BL-202 [Looking Glass]:** Configuración de cliente `looking-glass-client` con sincronización de frames a 144Hz y passthrough de teclado/ratón.
- [ ] **BL-203 [QEMU]:** Definición de plantilla XML para VM de ingeniería Windows 11 con disco virtual en subvolumen Btrfs (`nodatacow`).

### Épica 3: Hardware-in-the-Loop (HIL) & Instrumentación
- [ ] **BL-301 [Sigrok]:** Creación de decodificadores de protocolo personalizados en Python para telemetría UART/SPI/I2C de DanyBot.
- [x] **BL-302 [PlatformIO]:** Integración y verificación de PlatformIO Core v6.1.19 con compilación determinista para microcontroladores AVR/ARM.
- [ ] **BL-303 [Automated Flash]:** Watcher de compilación para volcado automático de firmware al detectar conexión de puerto serie.

### Épica 4: Higiene de Sistema, Btrfs y Gobernanza Continua
- [ ] **BL-401 [Btrfs Scrub]:** Temporizador systemd para ejecución mensual de `btrfs scrub` y balance de espacio libre.
- [ ] **BL-402 [Thermal Daemon]:** Servicio systemd en segundo plano para aplicar automáticamente `clisa_power_governor.sh` en eventos udev de conexión de cable USB-C / AC.
- [ ] **BL-403 [Battery Guard]:** Alerta sonora / OSD en Waybar cuando la batería baje del 20% o cuando la degradación supere el 20%.

---

## 2. MATRIZ DE DEUDA TÉCNICA Y MITIGACIÓN

| ID | Área | Riesgo | Acción Mitigadora |
| :--- | :--- | :--- | :--- |
| **DT-01** | Btrfs CoW en VMs | Fragmentación severa en imágenes `.qcow2` | Aplicar `chattr +C` en directorios de imágenes de VM. |
| **DT-02** | Kernel Updates | Regresión de parches o soporte `vfio` | Mantener snapshots Timeshift automáticos pre-DNF upgrade. |
| **DT-03** | Dual-Boot Windows | Sobrescritura de NVMe secundario | Mantener `/dev/nvme1n1` sellado sin entradas en `/etc/fstab`. |

