{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.autorandr;
in
{
  options = {
    modules.autorandr = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };

      profiles = mkOption {
        type = types.attrs;
        default = {};
      };
    };
  };

  config = mkIf cfg.enable {
    services.autorandr = {
      enable = true;
      profiles = cfg.profiles;
    };

    services.udev.extraRules = ''
      ACTION=="change", SUBSYSTEM=="drm", RUN+="${pkgs.autorandr}/bin/autorandr -c"
    '';
  };
}
