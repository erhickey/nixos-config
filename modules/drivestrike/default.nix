{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.modules.drivestrike;
  drivestrike  = import ../../pkgs/drivestrike/drivestrike.nix { pkgs = pkgs; lib = lib; };
in {
  options = {
    modules.drivestrike = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      drivestrike
    ];

    systemd.services.drivestrike = {
      enable = true;
      description = "DriveStrike Client Service";
      wantedBy = [ "multi-user.target" ];

      path = [
        pkgs.dmidecode
        pkgs.glib-networking
        drivestrike
      ];

      unitConfig = {
        Description = "DriveStrike Client Service";
        After = [
          "network.target"
          "drivestrike-lock.service"
        ];
      };

      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = "10";
        ExecStart = "${drivestrike}/bin/drivestrike run";
        SyslogIdentifier = "drivestrike";
      };
    };
  };
}
