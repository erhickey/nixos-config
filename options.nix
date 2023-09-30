{ config, pkgs, ... }:
let
  user = "eddie";
in
{
  options = {
    username = pkgs.lib.mkOption {
      default = "${user}";
    };
    nixos-version = pkgs.lib.mkOption {
      default = "23.05";
    };
    config-files = pkgs.lib.mkOption {
      default = "/home/${user}/repositories/nixos-config/config";
    };
  };
}
