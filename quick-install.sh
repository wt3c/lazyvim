#!/bin/bash
# Compatibilidade com instalações antigas: o fluxo único vive em install.sh.

set -euo pipefail

NVIM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "quick-install.sh agora delega para install.sh."
exec "$NVIM_DIR/install.sh" "$@"
