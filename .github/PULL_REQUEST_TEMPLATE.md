## Summary of Changes
<!-- Provide a clear and concise summary of the changes proposed in this Pull Request -->

Fixes #(issue)

## Type of Change

- [ ] New hardware / vendor profile adaptation
- [ ] IOMMU / VFIO passthrough improvement
- [ ] Wayland / Sway / compositor configuration update
- [ ] Power / thermal governor enhancement
- [ ] Bug fix / script correction
- [ ] Documentation / governance update

## Privacy & Hardware Security Verification

- [ ] **Zero Private Paths**: Verified that no hardcoded paths (e.g., `/home/<username>/`) exist; uses `$HOME`, `$USER`, or `${CLISA_ROOT}`.
- [ ] **Zero Hardware UUIDs/MACs**: Verified that no real disk UUIDs, MAC addresses, or personal hardware serials are committed.
- [ ] **Syntax Validation**: All modified shell scripts pass `bash -n` with zero warnings/errors.
- [ ] **Defensive Bash**: Scripts use `set -euo pipefail` where appropriate.

## Checklist

- [ ] My code adheres to the guidelines in [CONTRIBUTING.md](../CONTRIBUTING.md).
- [ ] I have read and agree to follow the [Code of Conduct](../CODE_OF_CONDUCT.md).
- [ ] Commits follow Conventional Commits guidelines.
- [ ] SPDX headers are present below the shebang on modified or new `.sh` files:
  ```bash
  # SPDX-License-Identifier: Apache-2.0
  # Copyright (C) 2024-2026 Alonso Alvarado Hernández <alonsoalvaradohr>
  ```
