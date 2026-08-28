# ARQUITECTURA DE SISTEMA Y TOPOLOGÍA INTEGRAL (CLISA FASE 20)
**Documento:** `docs/01_SYSTEM_ARCHITECTURE.md`  
**Autor:** Agente Arquitecto & CLISA-Core  
**Entorno:** Nobara Linux 44 // AMD Ryzen 7 7840HS // NVIDIA RTX 4060 Mobile

---

## 1. TOPOLOGÍA DE HARDWARE E IOMMU

La siguiente estructura describe la distribución del hardware físico, buses PCIe y grupos de aislamiento IOMMU en la estación de trabajo Lenovo LOQ 16:

```mermaid
graph TD
    subgraph "AMD Phoenix APU (Ryzen 7 7840HS - 8C/16T)"
        CPU["Zen 4 Cores (16 Threads)"]
        iGPU["AMD Radeon 780M (Mesa RADV ACO)"]
        DF["Data Fabric & Memory Controller (16GB DDR5)"]
    end

    subgraph "PCIe Complex & IOMMU Groups"
        G20["IOMMU Group 20: AMD Radeon 780M (06:00.0)"] --> iGPU
        G18["IOMMU Group 18: Samsung PM9B1 NVMe (04:00.0)"] --> SSD_Host["Host Linux SSD (953.9 GiB)"]
        G19["IOMMU Group 19: ADATA LEGEND 900 PRO (05:00.0)"] --> SSD_Win["Windows Dual-Boot (1.86 TiB - SELLADO)"]
        G1["IOMMU Group 1: AMD Phoenix GPP Bridge (00:01.1)"] --> dGPU["NVIDIA GeForce RTX 4060 Mobile (8GB)"]
        G16["IOMMU Group 16: Realtek RTL8111 GbE (02:00.0)"] --> LAN["Ethernet NIC"]
        G17["IOMMU Group 17: MediaTek MT7921 Wi-Fi 6E (03:00.0)"] --> WLAN["Wi-Fi / Bluetooth"]
    end

    CPU --> DF
    DF --> G20
    DF --> G18
    DF --> G19
    DF --> G1
```

---

## 2. ARQUITECTURA DE ALMACENAMIENTO Y SUBVOLÚMENES BTRFS

El disco principal del host implementa subvolúmenes Btrfs con compresión Zstandard en tiempo real y políticas de snapshotting mediante Timeshift y Snapper:

```mermaid
graph TD
    Disk["Samsung PM9B1 NVMe (953.9 GiB)"] --> p1["nvme0n1p1 (1.0 GiB FAT32 - /boot/efi)"]
    Disk --> p2["nvme0n1p2 (2.0 GiB ext4 - /boot)"]
    Disk --> p3["nvme0n1p3 (348.0 GiB Btrfs - Root)"]
    Disk --> p4["nvme0n1p4 (569.9 GiB Btrfs - Home)"]
    Disk --> p5["nvme0n1p5 (33.0 GiB NTFS - Reserva)"]

    p3 --> SubvolRoot["Subvol @ (/ - compress=zstd:1)"]
    p4 --> SubvolHome["Subvol @home (/home - compress=zstd:1)"]

    SubvolRoot --> SnapBase["Snapshot: @_CLISA_BASE_SECURE"]
    SubvolRoot --> SnapDaily["Snapshots Diarios (Timeshift Btrfs)"]

    subgraph "Aislamiento Inviolable"
        WinDisk["ADATA LEGEND 900 PRO (/dev/nvme1n1)"] --> WinParts["Particiones NTFS / Windows OS / Data"]
        style WinDisk fill:#ffebee,stroke:#c62828,stroke-width:2px;
        style WinParts fill:#ffebee,stroke:#c62828,stroke-width:1px;
    end
```

---

## 3. VIRTUALIZACIÓN KVM, IVSHMEM Y GPU PASSTHROUGH

Para cargas de simulación que requieren Windows aislado o aceleración gráfica directa:

```mermaid
graph LR
    Host["Nobara Linux Host (amdgpu / Wayland)"] --> KVM["Hipervisor KVM / QEMU (qemu:///system)"]
    KVM --> VM["Máquina Virtual de Simulación (CAD / Windows)"]
    
    IVSHMEM["/dev/shm/looking-glass (Memoria Compartida 0660)"] --> Host
    IVSHMEM --> VM
    
    dGPU["NVIDIA RTX 4060 Mobile"] -.->|vfio-pci passthrough| VM
    dGPU -.->|Modo Cómputo CUDA Host| Host
```

---

## 4. ORQUESTACIÓN DE SCRIPTS Y DEPENDENCIAS DE EJECUCIÓN

Los scripts en `scripts/` están organizados de forma modular e idempotente:

```mermaid
graph TD
    Deploy["CLISA Deployment Suite"] --> Fnd["clisa_sys_foundation.sh (Núcleo, Sysctl, DNF, Udev)"]
    Deploy --> Shd["clisa_phase6_shield.sh (Snapshots Btrfs & Arsenal)"]
    Deploy --> Dyn["clisa_power_governor.sh (Detector AC vs USB-C 140W)"]
    Deploy --> Thm["clisa_thermal_governance.sh (Anti-Throttling CPU Zen 4)"]
    Deploy --> Mat["clisa_matlab_silent_deploy.sh (Instalador no-interactivo)"]
    Deploy --> Syn["clisa_draconian_sync.sh (Purga de caché y Distro-Sync)"]

    Fnd --> CfgSys["config/99-clisa-*.conf"]
    Fnd --> CfgUdev["config/*udev.rules & config/60-libsigrok.rules"]
    Shd --> CfgTime["config/timeshift.json"]
    Mat --> CfgMat["config/installer_input.txt"]
```

---

## 5. CAPA DE INSTRUMENTACIÓN Y HARDWARE-IN-THE-LOOP (HIL)

La estación cuenta con soporte nativo sin root para adquisición de señales y programación de microcontroladores:

```mermaid
graph LR
    USB["Puertos USB-C / USB-A"] --> UdevEngine["Motor Udev (/etc/udev/rules.d/)"]
    
    UdevEngine --> RulesSigrok["60-libsigrok.rules (Saleae, FX2, Agilent, BM869)"]
    UdevEngine --> RulesPIO["99-platformio-udev.rules (FTDI, CH34x, STM32, Pico, Teensy)"]

    RulesSigrok --> PulseView["PulseView / Sigrok CLI"]
    RulesPIO --> PlatformIO["PlatformIO CLI / OpenOCD / Picocom"]

    PulseView --> DanyBot["DanyBot HIL Telemetry"]
    PlatformIO --> DanyBot
```

---

## 6. ENTORNO TILING Y ERGONOMÍA VISUAL (SWAY / WAYBAR)

El entorno gráfico está diseñado para una latencia cognitiva cero mediante Sway sobre Wayland:

| Workspace | Identificador | Asignación de Aplicaciones | Atajo de Lanzamiento |
| :--- | :--- | :--- | :--- |
| **1** | `1: DEV` | VS Code, Alacritty, Antigravity CLI | `Mod+F1` (`code`), `Mod+Return` (`alacritty`) |
| **2** | `2: CAD` | FreeCAD, Autodesk Fusion 360 | `Mod+F2` (`freecad`), `Mod+F3` (`fusion`) |
| **3** | `3: MANUF` | Creality Print, Slicers 3D | `Mod+F4` (`creality-print`) |
| **4** | `4: DOC` | TeXstudio, LaTeX Wrappers, Jupyter | `Mod+F5` (`texstudio`), `Mod+F6` (`jupyter`) |
| **5** | `5: SYS` | PulseView, MATLAB, Telemetría | `Mod+F7` (`pulseview`), `Mod+F9` (`matlab`) |
