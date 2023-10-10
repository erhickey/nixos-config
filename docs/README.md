# Install
Basic installation instructions. Placing these here for quick reference in case I forget how to perform certain steps.

`sda` is used throughout the instructions as an example. Replace it with the appropriate value in all cases.

Write NixOS minimal iso to USB:
```bash
sudo dd if=nixos.iso of=/dev/sda
```
Connect to wifi:
```bash
wpa_passphrase SSID PASSPHRASE > /etc/wpa_supplicant.conf
systemctl start wpa_supplicant
```

[Unencrypted File System Setup](./unencrypted.md)

[Encrypted File System Setup](./encrypted.md)

Generate/Edit Config:
```bash
nixos-generate-config --root /mnt
nix-env -f '<nixpkgs>' -iA vim
```

Add `git` package and the following line(s) to `/etc/nixos/configuration.nix`
```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

Install/Reboot/Set User Password
```bash
nixos-install
reboot
passwd USER
```

- Clone this repo
- Copy `/etc/nixos/hardware-configuration.nix` to `host/HOST/`
- Add `hardware-configuration.nix` to git staging area
- Rebuild NixOS
    ```bash
    sudo nixos-rebuild switch --flake .#CONTEXT-HOST-OS
    #example:
    sudo nixos-rebuild switch --flake .#personal-pavilion-g7-linux
    ```
