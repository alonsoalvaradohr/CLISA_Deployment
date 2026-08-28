# CLISA Deployment & Governance Infrastructure

Repositorio centralizado de gobernanza, configuración y despliegue de infraestructura para la estación de trabajo y laboratorio de ingeniería **CLISA**.

---

## 🏛️ Arquitectura de Versiones (3 Líneas de Vida)

| Línea de Vida | Rama / Tag | Propósito | Criterio de Estabilidad |
| :--- | :--- | :--- | :--- |
| **Stable** | `main` | Entorno de producción verificado y operativo. | Tests de hardware y scripts validados al 100%. |
| **Test** | `develop` | Integración continua y release candidates (`vX.Y.Z-rc.N`). | Validación de nuevas configuraciones y scripts. |
| **Deployed** | `v1.0.0` (Tags) | Instantáneas inmutables de producción para rollback exacto. | Firmado y documentado en bitácora de gobernanza. |

---

## ⚡ Guía Operativa de Actualización (One-Command Runbook)

Para actualizar la estación CLISA de manera determinista y sin interacción manual:

```bash
# Sincronización completa de producción (Stable / Deployed)
git checkout main && git pull --ff-only origin main

# Sincronización para banco de pruebas / desarrollo (Test)
git checkout develop && git pull --ff-only origin develop
```

---

## 📂 Estructura del Repositorio

```text
.
├── 01_Goal_Objective.md           # Declaración de objetivos y arquitectura general
├── 02_Hardware_Intelligence.md    # Especificaciones y topología de hardware
├── 03_Software_Intelligence.md    # Definición de stack de software y servicios
├── 04_Agent_Orchestration.md      # Orquestación y gobernanza agéntica
├── bin/                           # Binarios auxiliares (protegidos por .gitignore)
├── config/                        # Configuraciones de sistema (CPU, Mem, Sway, Waybar, Udev, Timeshift)
├── scripts/                       # Scripts de despliegue, seguridad, sincronización y gobernanza térmica
├── COMMAND_EXECUTION_AUDIT.md     # Registro de comandos y auditoría previa
├── IOMMU_GROUP_AUDIT.md           # Auditoría de aislamiento IOMMU / GPU Passthrough
├── GIT_GOVERNANCE_AUDIT.md        # Bitácora formal de control de versiones y consenso
└── README.md                      # Documentación principal de operaciones
```

---

## 🔒 Gobernanza de Seguridad
- Repositorio remoto configurado como **Privado**.
- Secretos, logs temporales, archivos de compilación y datos volátiles excluidos mediante `.gitignore` quirúrgico.
- Commits atómicos siguiendo la convención de [Conventional Commits](https://www.conventionalcommits.org/).
