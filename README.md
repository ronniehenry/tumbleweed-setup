# OpenSUSE Tumbleweed Bootstrap

A personal automation toolkit for quickly configuring a fresh OpenSUSE Tumbleweed installation.

This repository contains scripts that automate the repetitive post-installation tasks required to turn a clean OpenSUSE Tumbleweed installation into a ready-to-use workstation.

## Features

### postinstall.sh

Automates common workstation setup tasks:

- Sets the system hostname
- Performs a full Tumbleweed distribution upgrade
- Installs OPI and multimedia codecs
- Installs virtualization tools
  - QEMU/KVM
  - libvirt
  - virt-manager
- Enables and starts the libvirt service
- Installs preferred desktop fonts
  - Lato
  - JetBrains Mono
  - Noto Sans CJK
  - Noto Color Emoji
- Installs commonly used applications
  - Transmission
  - Fastfetch
- Installs development essentials
  - Git
  - Zsh
  - devel_basis pattern
- Installs Oh My Zsh (if not already installed)
- Configures the Oh My Zsh `bira` theme
- Sets Zsh as the default shell
- Adds the current user to:
  - libvirt
  - dialout
  - wheel

### battserv.sh

Installs and enables a custom battery charge threshold service.

The script:

- Copies the systemd service file into `/etc/systemd/system`
- Reloads systemd
- Enables the service
- Starts the service immediately

This is intended to help preserve battery health on supported hardware.

---

## Requirements

- OpenSUSE Tumbleweed
- Internet connectivity
- sudo privileges

---

## Usage

### Clone the repository

```bash
git clone https://github.com/ronniehenry/tumbleweed-setup.git
cd tumbleweed-setup
```

### Run the workstation bootstrap

```bash
chmod +x postinstall.sh
./postinstall.sh --host host-name
```

Example:

```bash
./postinstall.sh --host vivobook
```

### Install battery threshold service

```bash
chmod +x battserv.sh
./battserv.sh
```

---

## Repository Structure

```text
.
├── postinstall.sh
├── battserv.sh
└── services/
    └── battery-threshold.service
```

---

## Design Goals

The scripts are designed to be:

- Simple
- Readable
- Idempotent where practical
- Safe to rerun
- Suitable for personal workstation provisioning

This repository intentionally avoids configuration-management frameworks such as Ansible, Salt, or Nix in favor of lightweight Bash automation.

---

## Validation

Before creating a release, run:

```bash
shellcheck postinstall.sh
shellcheck battserv.sh
```

---

## Notes

- Some package installations may require user interaction.
- Group membership changes require logout or reboot.
- Battery threshold functionality depends on hardware support.
- A system reboot is recommended after execution.

---

## Roadmap

### v0.9

- Bootstrap automation
- Battery threshold service installer
- Error handling and validation
- Dependency checking
- Safer, repeatable execution

### v1.0

- ShellCheck-clean scripts
- Tested on a fresh Tumbleweed installation
- GitHub release

---

## License

MIT License (recommended)

or

GNU GPL v3 (if you want improvements to remain open source)
