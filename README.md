# Post NixOS Install Instructions

- Connect to wifi
    ```bash
    nmcli device wifi connect NETWORK password PASSWORD
    ```
- Add `git` package and the following lines to `/etc/nixos/configuration.nix`
    ```nix
    nix.package = pkgs.nixUnstable;
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    ```
- Rebuild NixOS
    ```bash
    nixos-rebuild switch
    ```
- Clone this repo and cd into it
- Copy `/etc/nixos/hardware-configuration.nix` to `host/HOST_NAME/`
- Add `hardware-configuration.nix` to git staging area
- Rebuild NixOS
    ```bash
    sudo nixos-rebuild switch --flake .#HOST_NAME
    ```
