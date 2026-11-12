#!/usr/bin/env bash
#
# OpenSUSE Tumbleweed post-install script
# Usage: ./postinstall.sh --host <hostname>

set -Eeuo pipefail

# ---- error handler ----
error() {
    printf '\033[1;31mERROR:\033[0m %s\n' "$*"
}

# ---- logger ----
log() {
    printf '\n\033[1;32m==>\033[0m %s\n' "$*"
}

# ---- command check ----
require_command() {
    command -v "$1" >/dev/null 2>&1 || {
        error "Missing command: $1"
        exit 1
    }
}

# ---- trapper ----
trap 'error "Installation failed at line $LINENO"' ERR

# ---- parse args ----
log "Checking if the required parameter was set"
MYHOSTNAME=""
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --host)
            [[ -n "${2:-}" ]] || {
                error "Missing hostname value"
                exit 1
            }

            MYHOSTNAME="$2"
            shift
            ;;
        *)
            error "Unknown parameter: $1"
            exit 1
            ;;
    esac
    shift
done

if [[ -z "$MYHOSTNAME" ]]; then
    error "--host <hostname> is required"
    exit 1
fi

# ---- check needed commands first ----
log "Verifying if the needed commands are present"
require_command sudo
require_command zypper
require_command curl
require_command hostnamectl
require_command rpm

# ---- set hostname ----
log "Setting hostname to $MYHOSTNAME"
sudo hostnamectl set-hostname "$MYHOSTNAME"

# ---- make sure there's internet ----
log "Check if internet is available"
curl -fsSL https://download.opensuse.org >/dev/null || {
    error "Internet connection required"
    exit 1
}

# ---- distro update ----
log "Distro update"
sudo zypper dup -y

# ---- enable OBS and install codecs ----
log "Install OBS and install codecs"
rpm -q opi >/dev/null 2>&1 || \
    sudo zypper in -y opi
sudo zypper refresh
opi codecs

# ---- install VM manager ----
log "Installing VM tools"
sudo zypper in -y qemu-kvm libvirt virt-manager
sudo systemctl enable --now libvirtd

# ---- install other desired packages ----
log "Installing packages not inluded in default"
readonly PACKAGES=(
    transmission-qt
    fastfetch
    zsh
    git
    lato-fonts
    jetbrains-mono-fonts
    google-noto-sans-cjk-fonts
    google-noto-color-emoji-fonts
)
sudo zypper in -y "${PACKAGES[@]}"

# ---- build-essential for tumbleweed ----
log "Installing basic developer tools pattern (devel_basis)"
sudo zypper in -y -t pattern devel_basis

# ---- setup oh-my-zsh, default theme, and defalut shell ----
log "Installing Oh My Zsh"
# --unattended: skip the interactive prompt and don't auto-launch a new zsh shell,
# which would otherwise take over the terminal and halt the rest of the script.
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    log "Installing Oh My Zsh"

    sh -c \
        "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
        "" \
        --unattended
fi

log "Setting Oh My Zsh theme to bira"
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="bira"/' "$HOME/.zshrc"

log "Setting zsh as the default shell"
if command -v zsh >/dev/null; then
    chsh -s "$(command -v zsh)"
fi

# ---- add user to requisite groups ----
log "adding current user to libvirt, dialout, wheel"
sudo usermod -aG libvirt,dialout,wheel "$USER"

# ---- done ----
log "Post-install complete. A reboot is recommended for firmware/kernel updates to take effect."
