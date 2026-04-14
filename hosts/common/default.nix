{ host, inputs, pkgs, stateVersion, timezone, ... }:
{
  system.stateVersion = "${stateVersion}";

  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nix;
    registry.nixpkgs.flake = inputs.nixpkgs;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  time.timeZone = "${timezone}";

  imports = if host == "wsl" then [ ] else [ ./non-wsl.nix ];
}
