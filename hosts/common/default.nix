{ inputs, pkgs, stateVersion, ... }:
{
  system.stateVersion = "${stateVersion}";

  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nix;
    registry.nixpkgs.flake = inputs.nixpkgs;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
}
