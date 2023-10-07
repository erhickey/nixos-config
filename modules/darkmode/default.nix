{ config, lib, ... }:
with lib;
let
  cfg = config.modules.darkmode;
in
{
  options = {
    modules.darkmode = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };

  config = mkIf cfg.enable {
    environment.etc = {
      "xdg/gtk-2.0/gtkrc".text = ''
        gtk-application-prefer-dark-theme=true
      '';
      "xdg/gtk-3.0/settings.ini".text = ''
        [Settings]
        gtk-application-prefer-dark-theme=true
      '';
      "xdg/gtk-4.0/settings.ini".text = ''
        [Settings]
        gtk-application-prefer-dark-theme=true
      '';
    };
  };
}
