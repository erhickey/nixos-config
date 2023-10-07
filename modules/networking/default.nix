{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.networking;
in
{
  options = {
    modules.networking = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };

      hostName = mkOption {
        type = types.str;
        default = "host";
      };

      users = mkOption {
        type = types.listOf types.str;
        default = [];
        description = lib.mdDoc ''
          Users to add to networkmanager group
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      dnsutils
    ];

    networking = {
      hostName = "${cfg.hostName}";
      networkmanager.enable = true;
    };

    users.users = builtins.listToAttrs (map (user: {
      name = "${user}";
      value = { extraGroups = [ "networkmanager" ]; };
    }) cfg.users);
  };
}
