{ config, pkgs, home-manager, ... }:
{
  imports = [
    home-manager.nixosModule
  ];

  # allow a rebuild without raising impure warning
  # https://github.com/divnix/digga/issues/30
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.${config.username} = {
    programs.home-manager.enable = true;

    home = {
      stateVersion = "${config.nixos-version}";
      username = "${config.username}";
      homeDirectory = "/home/${config.username}";

      file = {
        ".bash_autoload/zz_startx.sh" = {
          source = ../../config/bash_autoload/zz_startx.sh;
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
          source = ../../config/xmonad/xmonad.hs;
        };
      };
    };
  };
}
