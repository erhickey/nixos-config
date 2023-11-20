{ lib, pkgs, config, ... }: with lib;
let
  cfg = config.modules.pycal;
  pycal  = import ../../pkgs/pycal/pycal.nix { pkgs = pkgs; lib = lib; };
in {
  options = {
    modules.pycal = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      calendarFile = mkOption {
        type = types.str;
        default = "~/.config/pycal/calendar.ics";
      };
      calendarLinkFile = mkOption {
        type = types.str;
        default = "~/.config/pycal/pycal.link";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pycal
    ];

    systemd.user = {
      timers."cal-download" = {
        wantedBy = [ "timers.target" ];

        timerConfig = {
          OnBootSec = "0m";
          OnCalendar = "*:0/15"; # run on hour and on 15 minute intervals
          Unit = "cal-download.service";
        };
      };

      timers."cal-notify" = {
        wantedBy = [ "timers.target" ];

        timerConfig = {
          OnBootSec = "0m";
          OnCalendar = "*:0/5"; # run on hour and on 5 minute intervals
          Unit = "cal-notify.service";
        };
      };

      services."cal-download" = {
        script = ''
          ${pkgs.curl}/bin/curl -o ${cfg.calendarFile} "$(cat ${cfg.calendarLinkFile})"
        '';

        serviceConfig = {
          Type = "oneshot";
        };
      };

      services."cal-notify" = {
        script = ''
          ${pycal}/bin/pycal -n 10 | ${pkgs.findutils}/bin/xargs --no-run-if-empty -L1 ${pkgs.dunst}/bin/dunstify
        '';

        serviceConfig = {
          Type = "oneshot";
        };
      };
    };
  };
}
