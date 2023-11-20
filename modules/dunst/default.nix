{ lib, pkgs, config, ... }: with lib;
let
  cfg = config.modules.dunst;
in {
  options = {
    modules.dunst = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      dunst
    ];

    systemd.user.services.dunst = {
      unitConfig = {
        Description = "Dunst notification daemon";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      serviceConfig = {
        Type = "dbus";
        BusName = "org.freedesktop.Notifications";
        ExecStart = "${pkgs.dunst}/bin/dunst";
      };
    };
  };
}
