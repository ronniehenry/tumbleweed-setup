#!/bin/sh
sudo zypper dup
sudo zypper in opi
sudo zypper refresh
opi codecs
sudo zypper in flatpak
flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo zypper install qemu-kvm libvirt virt-manager
sudo systemctl enable --now libvirtd
sudo zypper in zsh git
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sudo usermod -aG libvirt,dialout,wheel $USER
sudo zypper in lato-fonts
sudo zypper in transmission-qt fastfetch
