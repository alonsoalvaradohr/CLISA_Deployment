# ROADMAP Y DEV BACKLOG (CLISA FASE 20)
**Documento:** `docs/02_DEV_BACKLOG.md`  
**Estado:** Activo y Priorizado  
**Métricas de Calidad:** ISO-Grade / Determinista / Cero Deuda Técnica

---

## 1. BACKLOG PRIORIZADO (SPRINT ROADMAP)

### Épica 1: Expansión del Arsenal Electromecánico (CAD / EDA / Simulación)
- [ ] **BL-101 [EDA]:** Despliegue de KiCad 8.x / 9.x con librerías completas de huellas (footprints) y modelos 3D STEP.
- [ ] **BL-102 [CAD]:** Creación de plantillas paramétricas en FreeCAD / OpenSCAD para prototipado rápido de piezas robóticas DanyBot.
- [ ] **BL-103 [LaTeX]:** Integración de macros avanzadas `circuitikz` y `karnaugh-map` en el árbol de TeX Live local.
- [ ] **BL-104 [ROS2]:** Aprovisionamiento de contenedor rootless Podman con ROS 2 Jazzy Jalisco / Humble para simulación de odometría y SLAM en DanyBot.

### Épica 2: Virtualización KVM y GPU Passthrough Dinámico
- [ ] **BL-201 [IOMMU]:** Script automatizado de conmutación en caliente (*hot-unbinding*) de la NVIDIA RTX 4060 entre `vfio-pci` y `nvidia-current`.
- [ ] **BL-202 [Looking Glass]:** Configuración de cliente `looking-glass-client` con sincronización de frames a 144Hz y passthrough de teclado/ratón.
- [ ] **BL-203 [QEMU]:** Definición de plantilla XML para VM de ingeniería Windows 11 con disco virtual en subvolumen Btrfs (`nodatacow`).

### Épica 3: Hardware-in-the-Loop (HIL) & Instrumentación
- [ ] **BL-301 [Sigrok]:** Creación de decodificadores de protocolo personalizados en Python para telemetría UART/SPI/I2C de DanyBot.
- [ ] **BL-302 [PlatformIO]:** Integración de scripts de test unitario (`pio test`) automatizados con microcontroladores STM32 y ESP32 en banco de pruebas.
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
