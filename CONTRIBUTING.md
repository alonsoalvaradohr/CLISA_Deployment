# Contributing to CLISA Deployment & Intelligent Infrastructure Suite

Thank you for your interest in contributing to **CLISA Deployment & Intelligent Infrastructure Suite**!

This project is licensed under the **Apache License 2.0 (`Apache-2.0`)**. To maintain deterministic infrastructure, reproducibility across hardware profiles, and strict privacy/security boundaries, all contributors must adhere to the guidelines set out below.

---

## 1. Code of Conduct

All contributors and community participants are expected to follow our [Code of Conduct](CODE_OF_CONDUCT.md) (Contributor Covenant v2.1).

---

## 2. Hardware Profiles, IOMMU & Wayland Adaptation Guidelines

CLISA orchestrates low-level Linux infrastructure (Sway/Wayland compositors, Btrfs subvolumes, IOMMU groups, VFIO GPU passthrough, and power/thermal governors). When contributing adaptations for new hardware architectures or vendor profiles:

1. **Zero Personal Identifiers & Hardware Privacy:**
   - **Never commit personal UUIDs, disk serial numbers, or MAC addresses.** Use generic placeholders such as `<DISK_UUID>`, `<PCI_DEVICE_ID>`, or parameterize variables (e.g., `${TARGET_DISK_UUID}`).
   - **Never hardcode personal user paths** (e.g., `/home/username/`). Always utilize standard POSIX environment variables: `$HOME`, `$USER`, `${CLISA_ROOT:-/opt/clisa}`, `${RND_WORKSPACE:-/opt/rnd_workspace}`, or `${USER_LOCAL:-~/.local}`.
   - Run a strict regex or security check prior to staging files to ensure no sensitive workstation data or tokens leak.

2. **IOMMU & VFIO Passthrough Modularity:**
   - Keep PCI vendor/device mappings modular. Configuration fragments must isolate vendor-specific quirks (AMD Zen, Intel Alder Lake, NVIDIA Ada Lovelace, etc.) into designated override files or script parameters without hardcoding them into foundational orchestrators.

3. **Wayland & Sway Display Environment:**
   - Display configurations (`config/sway/`, `config/waybar/`, `config/alacritty/`) should remain resolution-agnostic or provide parameterized scale/output bindings.
   - Do not commit hardcoded monitor serial numbers or display EDID hashes into default configs.

---

## 3. Shell Script Standards & Syntax Validation

All shell scripts in `scripts/` and `config/` must conform to defensive scripting principles:

1. **Bash Strict Mode:**
   - Executable scripts must begin with `#!/usr/bin/env bash` followed immediately by the SPDX header:
     ```bash
     #!/usr/bin/env bash
     # SPDX-License-Identifier: Apache-2.0
     # Copyright (C) 2024-2026 Alonso Alvarado Hernández <alonsoalvaradohr>
     ```
   - Enforce strict error handling: `set -euo pipefail`.
2. **Syntax Verification:**
   - All shell scripts must pass syntax validation with zero errors:
     ```bash
     bash -n scripts/*.sh config/clisa_aliases.sh
     ```

---

## 4. Semantic Commit Guidelines (Conventional Commits)

We enforce semantic commit messages adhering to the [Conventional Commits](https://www.conventionalcommits.org/) specification:

- `feat:` Introduces a new feature, hardware profile, or governor policy.
- `fix:` Patches a bug or configuration error.
- `docs:` Documentation updates, architecture guides, or comments.
- `refactor:` Code restructuring without altering deployment behavior.
- `perf:` Performance tuning (e.g., latency reduction, thermal curves).
- `chore:` Maintenance tasks, dependency updates, template changes.

*Example:* `feat(governor): add support for USB-C PD 100W power profiling`

---

## 5. Pull Request Process

1. Fork the repository and create a feature branch (`feat/hardware-profile-name` or `fix/iommu-grouping`).
2. Run syntax verification (`bash -n`) across all modified shell files.
3. Verify that zero private paths, UUIDs, or credentials exist in the diff.
4. Submit your Pull Request using the [.github/PULL_REQUEST_TEMPLATE.md](.github/PULL_REQUEST_TEMPLATE.md).
