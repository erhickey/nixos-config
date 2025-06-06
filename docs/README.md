# Install
Basic installation instructions. Placing these here for quick reference in case I forget how to perform certain steps.

`sda` is used throughout the instructions as an example. Replace it with the appropriate value in all cases.

Write NixOS minimal iso to USB:
```bash
sudo dd if=nixos.iso of=/dev/sda
```
Connect to wifi:
```bash
sudo -i
systemctl start wpa_supplicant
wpa_cli
add_network
set_network 0 ssid "SSID"
set_network 0 psk "PASSPHRASE"
set_network 0 key_mgmt WPA-PSK
enable_network 0
```

[Unencrypted File System Setup](./unencrypted.md)

[Encrypted File System Setup](./encrypted.md)

Generate/Edit Config:
```bash
nixos-generate-config --root /mnt
```

Add `git` package and the following line(s) to `/mnt/etc/nixos/configuration.nix`
```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
networking.wireless.enable = true;
```

If an encrypted file system is being used, the following line may need to be added to `/mnt/etc/nixos/hardware-configuration.nix` (use `:r!blkid` in vim to easily get the /dev/sda2 UUID):
```nix
boot.initrd.luks.devices.crypto.device = "/dev/disk/by-uuid/UUID";
```

Install/Reboot/Set User Password
```bash
nixos-install
reboot
```

After reboot:
```bash
wpa_passphrase SSID PASSPHRASE > /etc/wpa_supplicant.conf
systemctl restart wpa_supplicant.service
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

Post install:
```bash
passwd USER
cp /etc/xdg/startx/xinitrc /home/USER/.xinitrc
chown USER:users /home/USER/.xinitrc
```

# Upgrade

- Update `nixpkgs.url` and `stateVersion` in `flake.nix`
- Update `nixpkgs-unstable` with the following command:
    ```bash
    nix flake update nixpkgs-unstable
    ```
