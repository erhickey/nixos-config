{ config, pkgs, home-manager, ... }:
let
  uname = "${config.username}";
  version = "${config.nixos-version}";
  configFiles = "${config.config-files}";
in
{
  imports = [
    home-manager.nixosModule
  ];

  # allow a rebuild without raising impure warning
  # https://github.com/divnix/digga/issues/30
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.${config.username} = { config, ... }: {
    programs.home-manager.enable = true;

    home = {
      stateVersion = version;
      username = uname;
      homeDirectory = "/home/${uname}";

      file = {
        ".bash_autoload/zz_startx.sh" = {
          source = ../../config/bash_autoload/zz_startx.sh;
          executable = true;
        };

        ".config/background.jpg" = {
          source = ../../config/wallpaper/calvin-hobbes-autumn.jpg;
        };

        ".config/picom.conf" = {
          source = ../../config/picom/picom.conf;
        };

        ".gnupg/gpg-agent.conf" = {
          source = ../../config/gnupg/gpg-agent.conf;
        };

        ".xinitrc" = {
          source = ../../config/xinit/xinitrc;
        };

        ".xmonad/xmonad.hs" = {
          source = config.lib.file.mkOutOfStoreSymlink "${configFiles}/xmonad/xmonad.hs";
        };
      };
    };
  };
}
