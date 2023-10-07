{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.autolockandsuspend;
in
{
  options = {
    modules.autolockandsuspend = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
        xorg.xset
        xss-lock
      ];
    };

    services.physlock = {
      enable = true;
    };
  };
}
