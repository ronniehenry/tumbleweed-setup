#!/usr/bin/env bash
#
# Battery service support script
# Usage: ./battserv.sh

set -Eeuo pipefail

error() {
    printf '\033[1;31mERROR:\033[0m %s\n' "$*"
}

trap 'error "Installation failed at line $LINENO"' ERR

log() {
    printf '\n\033[1;32m==>\033[0m %s\n' "$*"
}

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# copy service script to systemd
log "Copying service script to systemd"
sudo install -Dm644 \
    "$SCRIPT_DIR/services/battery-threshold.service" \
    /etc/systemd/system/battery-threshold.service

# enable service to set battery charge to 80% maximum
log "Enable battery charge limit service through systemd"
sudo systemctl daemon-reload
sudo systemctl enable --now battery-threshold.service

log "Battery charge limit service setup complete."
