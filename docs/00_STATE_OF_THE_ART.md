# ESTADO DEL ARTE Y FUNDAMENTOS ONTOLÓGICOS (CLISA FASE 20)
**Documento:** `docs/00_STATE_OF_THE_ART.md`  
**Ecosistema:** Core Linux Intelligent System Architecture (CLISA)  
**Host Físico:** Lenovo LOQ 16APH8 (AMD Ryzen 7 7840HS // NVIDIA GeForce RTX 4060 Mobile // 16GB DDR5 5600MT/s)  
**Entorno Operativo:** Nobara Linux 44 (Base Fedora 44 // Kernel Linux 7.1.x Zen-tuned // Wayland Sway + KDE Plasma)

---

## 1. GÉNESIS Y MISIÓN DEL PROYECTO CLISA
El proyecto **CLISA (Core Linux Intelligent System Architecture)** nace de la necesidad imperativa de transformar una estación de trabajo móvil de alto rendimiento en un laboratorio electromecánico, de simulación multifísica y de orquestación robótica hermético, determinista y de latencia cognitiva cero.

El objetivo central es erradicar la fricción operativa entre el pensamiento del ingeniero y la ejecución en el silicio, proporcionando un entorno reproducible donde los proyectos insignia **DanyBot** (robótica móvil autónoma y control de tiempo real) y **CMU** (investigación y desarrollo de modelos analíticos avanzados) puedan evolucionar sin riesgos de regresión, degradación térmica o colapso de dependencias.

---

## 2. JUSTIFICACIÓN TÉCNICA DE LAS DECISIONES ARQUITECTÓNICAS

### 2.1. Nobara Linux (Fedora 44 Base) + Kernel Zen/SteamOS Tuned
* **Razón de Selección:** Nobara proporciona parches de baja latencia en el programador del kernel (*kernel scheduler*), soporte nativo para drivers híbridos (APU AMD + dGPU NVIDIA), dependencias multimedia PipeWire optimizadas y compatibilidad con `fsync` y `futex2`.
* **Beneficio R&D:** Minimiza la sobrecarga de interrupciones (*interrupt latency*) en adquisición de datos por USB-Serial y compilación masiva de C++ / Rust para microcontroladores.

### 2.2. Topología de Procesamiento Híbrido: AMD Zen 4 + NVIDIA Ada Lovelace
* **APU AMD Ryzen 7 7840HS (8C/16T Phoenix):**
  * Maneja el renderizado del escritorio completo bajo Wayland a través de la iGPU **AMD Radeon 780M** (Mesa RADV ACO).
  * Eficiencia energética extrema en operación de batería y carga base de documentación.
* **dGPU NVIDIA GeForce RTX 4060 Mobile (8GB GDDR6):**
  * Aislada en su propio bus PCIe con soporte de conmutación para cómputo CUDA/OptiX en el host o aislamiento vía `vfio-pci` para passthrough hacia máquinas virtuales KVM de simulación.

### 2.3. Almacenamiento Btrfs con Compresión Zstandard (`zstd:1`)
* **Particionamiento:** El host Linux reside en el SSD Samsung PM9B1 (953.9 GiB NVMe Gen4), particionado en subvolúmenes Btrfs `@` (raíz) y `@home` (datos de usuario).
* **Beneficios:**
  * Compresión transparente en tiempo real que reduce el desgaste de las celdas NAND y duplica el rendimiento efectivo de lectura/escritura en datasets grandes de MATLAB y simulaciones.
  * Capacidad de snapshots instantáneos antes de actualizaciones críticas mediante Timeshift y Snapper.

### 2.4. Aislamiento Físico e Inviolabilidad de Windows Dual-Boot
* **Unidad Secundaria:** SSD A-DATA LEGEND 900 PRO (1.86 TiB NVMe Gen4 en `/dev/nvme1n1`).
* **Directiva Inmutable 01:** Aislado en el Grupo IOMMU 19. Ningún script automatizado ni agente tiene autorización de escritura, protegiendo las particiones NTFS y el firmware OEM contra corrupción accidental.

### 2.5. Entorno Tiling Paramétrico (Sway + Waybar) vs Desktop Convencional
* **Sway (Wayland):** Ofrece un control por teclado sin distracciones visuales. Los 5 espacios de trabajo (`DEV`, `CAD`, `MANUF`, `DOC`, `SYS`) están consolidados para un flujo de trabajo enfocado.
* **Ergonomía de Trackball:** Mapeo de aceleración plana (`pointer_accel 0`) y emulación de scroll con botón central (`scroll_button 274`) para diseño CAD de alta precisión.

---

## 3. FLUJOS DE TRABAJO INSIGNIA (DANYBOT & CMU)

```text
+-------------------------------------------------------------------------------+
|                             PROYECTO CLISA (R&D)                              |
+---------------------------------------+---------------------------------------+
|          PROYECTO DANYBOT             |             PROYECTO CMU              |
|       (Robótica & Embebidos)          |        (Modelado & Simulación)        |
+---------------------------------------+---------------------------------------+
| * Toolchains ARM (GCC, OpenOCD, PIO)  | * MATLAB & Simulink Runtime           |
| * Telemetría Serial (Sigrok, Logic)   | * LaTeX Científico (TeX Live, TeXstudio)|
| * Firmware Flashing determinista      | * Jupyter Lab & Python Científico     |
| * Modelado Mecánico 3D (CAD/CAM)      | * Virtualización KVM / Looking Glass  |
+---------------------------------------+---------------------------------------+
```

---

## 4. GOBERNANZA DE ENERGÍA Y PERFILES TÉRMICOS (AC vs USB-C 140W PD)
La arquitectura implementa un gobernador dinámico (`scripts/clisa_power_governor.sh` y `scripts/clisa_thermal_governance.sh`) que detecta la fuente de alimentación:
1. **AC High Power (Cargador OEM):** CPU en modo `performance`, EPP `performance`, piso de frecuencia fijado en 1100 MHz para erradicar cualquier *thermal throttling* espurio.
2. **USB-C PD 140W / Batería:** CPU en modo `balanced` / `powersave`, EPP `balance_performance`, protegiendo la química de la batería (salud basal: 84.2%) y evitando picos de corriente que disparen protecciones térmicas.
