# [AUDITORÍA DE AISLAMIENTO IOMMU Y TOPOLOGÍA PCIE (CLISA FASE 13)]

**Estación de Trabajo:** LENOVO LOQ 16APH8 (AMD Ryzen 7 7840HS / AMD Phoenix Root Complex)
**Tecnología de Virtualización:** AMD-Vi (IOMMU) Habilitada // Kernel `7.1.3-200.nobara.fc44.x86_64`
**Fecha de Auditoría:** 2026-08-21

---

## 1. RESUMEN EJECUTIVO DE TOPOLOGÍA Y VIABILIDAD DE PASSTHROUGH

* **Aislamiento de Almacenamiento Dual-Boot (Directiva Inmutable 01):**
  * `Group 18`: SSD Host Samsung PM9B1 (`04:00.0` [144d:a80b] - Linux Btrfs) en dominio IOMMU independiente.
  * `Group 19`: SSD Secundario ADATA LEGEND 900 PRO (`05:00.0` [1cc1:64ba] - Windows Dual-Boot) en dominio IOMMU aislado e inviolable.
* **Matriz Gráfica Primaria (Host Render):**
  * `Group 20`: AMD Radeon 780M Graphics (`06:00.0` [1002:15bf] - `amdgpu` Mesa RADV ACO) con bus e IOMMU dedicada.
* **Puente PCIe dGPU (NVIDIA RTX 4060 Mobile):**
  * `Group 1`: AMD Phoenix GPP Bridge (`00:01.1` [1022:14ed] - `pcieport`), puerto raíz dedicado para passthrough hacia VM KVM.
* **Aislamiento de Conectividad y Red:**
  * `Group 16`: Realtek Gigabit Ethernet RTL8111/8168 (`02:00.0` [10ec:8168] - `r8169`) aislado.
  * `Group 17`: MediaTek Wi-Fi 6E MT7921 (`03:00.0` [14c3:7961] - `mt7921e`) aislado.

---

## 2. MATRIZ DETALLADA DE GRUPOS IOMMU

| Grupo IOMMU | Dirección PCI (BDF) | ID Dispositivo | Nombre del Dispositivo | Driver de Kernel Activo |
| :--- | :--- | :--- | :--- | :--- |
| **Group 0** | `0000:00:01.0` | `[1022:14ea]` | Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Phoenix Dummy Host Bridge | `--` |
| **Group 1** | `0000:00:01.1` | `[1022:14ed]` | PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Phoenix GPP Bridge | `pcieport` |
| **Group 2** | `0000:00:02.0` | `[1022:14ea]` | Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Phoenix Dummy Host Bridge | `--` |
| **Group 3** | `0000:00:02.1` | `[1022:14ee]` | PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Phoenix GPP Bridge | `pcieport` |
| **Group 4** | `0000:00:02.2` | `[1022:14ee]` | PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Phoenix GPP Bridge | `pcieport` |
| **Group 5** | `0000:00:02.3` | `[1022:14ed]` | PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Phoenix GPP Bridge | `pcieport` |
| **Group 6** | `0000:00:02.4` | `[1022:14ee]` | PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Phoenix GPP Bridge | `pcieport` |
| **Group 7** | `0000:00:03.0` | `[1022:14ea]` | Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Phoenix Dummy Host Bridge | `--` |
| **Group 8** | `0000:00:04.0` | `[1022:14ea]` | Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Phoenix Dummy Host Bridge | `--` |
| **Group 9** | `0000:00:08.0` | `[1022:14ea]` | Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Phoenix Dummy Host Bridge | `--` |
| **Group 10** | `0000:00:08.1` | `[1022:14eb]` | PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Phoenix Internal GPP Bridge to Bus [C:A] | `pcieport` |
| **Group 11** | `0000:00:08.2` | `[1022:14eb]` | PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Phoenix Internal GPP Bridge to Bus [C:A] | `pcieport` |
| **Group 12** | `0000:00:08.3` | `[1022:14eb]` | PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Phoenix Internal GPP Bridge to Bus [C:A] | `pcieport` |
| **Group 13** | `0000:00:14.0` | `[1022:790b]` | SMBus [0c05]: Advanced Micro Devices, Inc. [AMD] FCH SMBus Controller | `piix4_smbus` |
| **Group 13** | `0000:00:14.3` | `[1022:790e]` | ISA bridge [0601]: Advanced Micro Devices, Inc. [AMD] FCH LPC Bridge | `--` |
| **Group 14** | `0000:00:18.0` | `[1022:14f0]` | Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Phoenix Data Fabric; Function 0 | `--` |
| **Group 14** | `0000:00:18.1` | `[1022:14f1]` | Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Phoenix Data Fabric; Function 1 | `--` |
| **Group 14** | `0000:00:18.2` | `[1022:14f2]` | Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Phoenix Data Fabric; Function 2 | `--` |
| **Group 14** | `0000:00:18.3` | `[1022:14f3]` | Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Phoenix Data Fabric; Function 3 | `k10temp` |
| **Group 14** | `0000:00:18.4` | `[1022:14f4]` | Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Phoenix Data Fabric; Function 4 | `--` |
| **Group 14** | `0000:00:18.5` | `[1022:14f5]` | Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Phoenix Data Fabric; Function 5 | `--` |
| **Group 14** | `0000:00:18.6` | `[1022:14f6]` | Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Phoenix Data Fabric; Function 6 | `--` |
| **Group 14** | `0000:00:18.7` | `[1022:14f7]` | Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Phoenix Data Fabric; Function 7 | `--` |
| **Group 16** | `0000:02:00.0` | `[10ec:8168]` | Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8111/8168/8211/8411 PCI Express Gigabit Ethernet Controller | `r8169` |
| **Group 17** | `0000:03:00.0` | `[14c3:7961]` | Network controller [0280]: MEDIATEK Corp. MT7921 802.11ax PCIe Wireless Network Adapter [Filogic 330] | `mt7921e` |
| **Group 18** | `0000:04:00.0` | `[144d:a80b]` | Non-Volatile memory controller [0108]: Samsung Electronics Co Ltd NVMe SSD Controller PM9B1 (DRAM-less) | `nvme` |
| **Group 19** | `0000:05:00.0` | `[1cc1:64ba]` | Non-Volatile memory controller [0108]: ADATA Technology Co., Ltd. LEGEND 900 PRO NVMe SSD | `nvme` |
| **Group 20** | `0000:06:00.0` | `[1002:15bf]` | VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/ATI] Phoenix1 | `amdgpu` |
| **Group 21** | `0000:06:00.2` | `[1022:15c7]` | Encryption controller [1080]: Advanced Micro Devices, Inc. [AMD] Phoenix CCP/PSP 3.0 Device | `ccp` |
| **Group 22** | `0000:06:00.3` | `[1022:15b9]` | USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] Device | `xhci_hcd` |
| **Group 23** | `0000:06:00.4` | `[1022:15ba]` | USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] Device | `xhci_hcd` |
| **Group 24** | `0000:06:00.5` | `[1022:15e2]` | Multimedia controller [0480]: Advanced Micro Devices, Inc. [AMD] Audio Coprocessor | `snd_pci_ps` |
| **Group 25** | `0000:06:00.6` | `[1022:15e3]` | Audio device [0403]: Advanced Micro Devices, Inc. [AMD] Ryzen HD Audio Controller | `snd_hda_intel` |
| **Group 26** | `0000:07:00.0` | `[1022:14ec]` | Non-Essential Instrumentation [1300]: Advanced Micro Devices, Inc. [AMD] Phoenix Dummy Function | `--` |
| **Group 27** | `0000:08:00.0` | `[1022:14ec]` | Non-Essential Instrumentation [1300]: Advanced Micro Devices, Inc. [AMD] Phoenix Dummy Function | `--` |
| **Group 28** | `0000:08:00.3` | `[1022:15c0]` | USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] Device | `xhci_hcd` |
| **Group 29** | `0000:08:00.4` | `[1022:15c1]` | USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] Device | `xhci_hcd` |

---

## 3. CERTIFICACIÓN DE ARQUITECTURA DE VIRTUALIZACIÓN

1. **Inviolabilidad de Almacenamiento:** El disco Windows (`nvme1n1` / ADATA en `05:00.0`) opera en su propio dominio IOMMU (Grupo 19), permitiendo mantenerlo en aislamiento total respecto a las operaciones de la estación de trabajo.
2. **Soporte IVSHMEM / Looking Glass:** Espacio de memoria compartida inter-máquina provisionado en `/dev/shm/looking-glass` (permisos `0660 $USER:libvirt` con regla persistente en `~/.config/user-tmpfiles.d/10-looking-glass.conf`).
3. **Hipervisor KVM / QEMU:** Arquitectura validada bajo `qemu:///system` con 16 vCPUs y red NAT `default` lista para máquinas virtuales de ingeniería.
