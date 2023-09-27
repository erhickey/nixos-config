{ config, lib, pkgs, ... }:
{
  imports =
    [
      ../common
    ];

  home-manager.users.${config.username} = {
    home = {
      file = {
        ".config/polybar/config.ini" = {
          text = lib.strings.concatStrings [
            (builtins.readFile ../../config/polybar/common.appearance.ini)
            "\n"
            (builtins.readFile ../../config/polybar/hp-notebook.bar.ini)
            "\n"
            (builtins.readFile ../../config/polybar/common.modules.ini)
            "\n"
            (builtins.readFile ../../config/polybar/common.battery.module.ini)
            "\n"
            (builtins.readFile ../../config/polybar/hp-notebook.battery.ini)
          ];
        };
      };
    };
  };
}
