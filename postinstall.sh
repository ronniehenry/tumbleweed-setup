#!/bin/sh
#
# OpenSUSE Tumbleweed post-install script
# Usage: ./postinstall.sh --host <hostname>

set -euo pipefail

# ---- logger ----
log() { echo -e "\n\033[1;32m==>\033[0m $*"; }

# ---- parse args ----
MYHOSTNAME=""
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --host) MYHOSTNAME="$2"; shift ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

if [[ -z "$MYHOSTNAME" ]]; then
    echo "Error: --host <hostname> is required"
    exit 1
fi

# ---- hostname ----
log "Setting hostname to $MYHOSTNAME"
sudo hostnamectl set-hostname "$MYHOSTNAME"

# ---- distro update ----
log "Distro update"
sudo zypper dup

# ---- enable OBS and install codecs ----
log "Install OBS and install codecs"
sudo zypper in opi
sudo zypper refresh
opi codecs

# ---- install flatpak and enable user repository
log "Installing flatpak and adding user repository"
sudo zypper in flatpak
flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# ---- install VM manager ----
log "Installing VM tools"
sudo zypper install qemu-kvm libvirt virt-manager
sudo systemctl enable --now libvirtd

# ---- install favorite fonts ----
log "Installing Lato for clearer UI fonts"
sudo zypper in lato-fonts

# ---- install favorite apps ----
log "Installing favorite apps"
sudo zypper in transmission-qt fastfetch

# ---- installing zsh and git ----
log "Installing zsh and git"
sudo zypper in zsh git

# ---- setup oh-my-zsh, default theme, and defalut shell ----
log "Installing Oh My Zsh"
# --unattended: skip the interactive prompt and don't auto-launch a new zsh shell,
# which would otherwise take over the terminal and halt the rest of the script.
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

log "Setting Oh My Zsh theme to bira"
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="bira"/' "$HOME/.zshrc"

log "Setting zsh as the default shell"
chsh -s $(which zsh)

# ---- add user to requisite groups ----
log "adding current user to libvirt, dialout, wheel"
sudo usermod -aG libvirt,dialout,wheel $USER

# ---- done ----
log "Post-install complete. A reboot is recommended for firmware/kernel updates to take effect."
