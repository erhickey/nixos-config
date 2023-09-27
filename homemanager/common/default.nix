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
    home = {
      stateVersion = "${config.nixos-version}";
      username = "${config.username}";
      homeDirectory = "/home/${config.username}";

      file = {
        ".config/background.jpg" = {
          source = ../../config/wallpaper/calvin-hobbes-autumn.jpg;
        };

        ".config/pavucontrol.ini" = {
          source = ../../config/pavucontrol/pavucontrol.ini;
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
    programs = {
      home-manager.enable = true;
    };
  };
}
