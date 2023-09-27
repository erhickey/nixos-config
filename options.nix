{ config, pkgs, ... }:
{
  options = {
    username = pkgs.lib.mkOption {
      default = "eddie";
    };
    nixos-version = pkgs.lib.mkOption {
      default = "23.05";
    };
  };
}
