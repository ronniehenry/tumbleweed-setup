# OpenSUSE Tumbleweed Laptop Setup

Personal post-installation automation scripts for setting up a fresh OpenSUSE Tumbleweed installation on a laptop.

The goal is to reduce repetitive configuration work after a clean install and quickly restore a productive development workstation.

## Included Scripts

### postinstall.sh

Performs common post-install tasks:

- Sets the system hostname
- Updates the system using `zypper dup`
- Installs `opi` and multimedia codecs
- Installs KVM/QEMU virtualization tools
- Enables the `libvirtd` service
- Installs preferred fonts:
  - Lato
  - JetBrains Mono
- Installs preferred applications:
  - Transmission
  - Fastfetch
- Installs:
  - Zsh
  - Git
  - Development tools (`devel_basis` pattern)
- Installs Oh My Zsh
- Configures the Oh My Zsh `bira` theme
- Sets Zsh as the default shell
- Adds the current user to:
  - libvirt
  - dialout
  - wheel

### battserv.sh

Installs and enables a custom systemd service that enforces a battery charging limit.

This is intended for laptops that support battery charge thresholds, helping reduce long-term battery wear.

Actions performed:

- Copies `battery-threshold.service` into `/etc/systemd/system`
- Enables the service through systemd

## Requirements

- OpenSUSE Tumbleweed
- Internet connection
- sudo privileges
- Git (if cloning the repository)

## Usage

### Clone the repository

```bash
git clone https://github.com/ronniehenry/tumbleweed-setup.git
cd tumbleweed-setup
```

### Run the post-install script

```bash
chmod +x postinstall.sh
./postinstall.sh --host <your preferred hostname>
```

Example:

```bash
./postinstall.sh --host tumbleweed-laptop
```

### Install battery threshold service

```bash
chmod +x battserv.sh
./battserv.sh
```

## Directory Structure

```text
.
├── postinstall.sh
├── battserv.sh
└── services/
    └── battery-threshold.service
```

## Notes

- The script assumes a fresh OpenSUSE Tumbleweed installation.
- Some changes require a logout or reboot before taking effect.
- Virtualization support may require BIOS/UEFI virtualization features to be enabled.
- Battery threshold functionality depends on hardware and kernel support.

## After Installation

Recommended next steps:

1. Reboot the system.
2. Verify group membership changes.
3. Verify libvirt is running:

```bash
systemctl status libvirtd
```

4. Confirm the default shell:

```bash
echo $SHELL
```

5. Verify battery threshold service:

```bash
systemctl status battery-threshold.service
```

## Disclaimer

These scripts reflect my personal workstation preferences and may not be suitable for every OpenSUSE installation. Review the scripts before executing them and adapt them to your own requirements.
