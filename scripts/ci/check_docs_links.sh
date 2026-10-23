#!/bin/bash
# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
# Check that every link in the Sphinx docs resolves, and that the docs do not point at
# NVIDIA-internal hosts. Internal hosts resolve on GitLab runners but are unreachable for
# public GitHub readers, so they are rejected explicitly rather than left to the link check.
#
# Run this on the public release surface (the GitHub checkout or the copybara export), where
# internal-only pages and sections have already been removed.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."

INTERNAL_HOSTS='gitlab-master(-pages)?\.nvidia\.com'
if grep -rnE "$INTERNAL_HOSTS" docs/source; then
  echo "error: docs link to internal hosts (above); use the public GitHub equivalents." >&2
  exit 1
fi

uv run --frozen --only-group docs sphinx-build -b linkcheck docs/source docs/build/linkcheck
