{ config, lib, pkgs, ... }:
{
  imports =
    [
      ../common
    ];

  home-manager.users.${config.username} = {
    home = {
      file = {
        ".mbsyncrc" = {
          source = ../../config/mbsync/rivet-thinkpad.mbsyncrc;
        };

        ".config/mutt/muttrc" = {
          source = ../../config/neomutt/rivet-thinkpad.muttrc;
        };

        ".config/polybar/config.ini" = {
          text = lib.strings.concatStrings [
            (builtins.readFile ../../config/polybar/common.appearance.ini)
            "\n"
            (builtins.readFile ../../config/polybar/rivet-thinkpad.bar.ini)
            "\n"
            (builtins.readFile ../../config/polybar/common.modules.ini)
            "\n"
            (builtins.readFile ../../config/polybar/rivet-thinkpad.modules.ini)
            "\n"
            (builtins.readFile ../../config/polybar/common.battery.module.ini)
            "\n"
            (builtins.readFile ../../config/polybar/rivet-thinkpad.battery.ini)
          ];
        };

        ".config/polybar/mail.sh" = {
          source = ../../config/polybar/mail.sh;
          executable = true;
        };
      };
    };
  };
}
