{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.x;
in
{
  options = {
    modules.x= {
      enable = mkOption {
        type = types.bool;
        default = false;
      };

      picom.enable = mkOption {
        type = types.bool;
        default = true;
      };

      users = mkOption {
        type = types.listOf types.str;
        default = [];
        description = lib.mdDoc ''
          Users to add to video group
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
        dmenu
        feh
        firefox
        google-chrome
        keepassxc
        maim
        qutebrowser
        sxiv
        vlc
        xclip
        st
      ];

      etc."xdg/backgrounds/background.jpg" = {
        source = ./backgrounds/calvin-hobbes-autumn.jpg;
        mode = "0444";
      };
    };

    services.xserver = {
      enable = true;
      autorun = false;
      displayManager.startx.enable = true;

      excludePackages = with pkgs; [
        xorg.iceauth
        xterm
        nixos-icons
      ];

      # keyboard settings
      xkb.layout = "us";
      xkb.variant = "";
      autoRepeatDelay = 200;
      autoRepeatInterval = 20;

      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        config = builtins.readFile ./xmonad/xmonad.hs;
      };
    };

    services.picom = mkIf cfg.picom.enable {
      enable = true;
      backend = "glx";
      inactiveOpacity = 0.95;

      settings = {
        corner-radius = 10;
      };

      opacityRules = [
        "90:class_g = 'st-256color' && !focused"
      ];
    };

    services.autorandr.hooks.postswitch.redrawBg =
      "feh --no-fehbg --bg-fill /etc/xdg/backgrounds/background.jpg";

    # 'light' backlight control command
    # use requires video group membership
    programs.light.enable = true;

    users.users = builtins.listToAttrs (map (user: {
      name = "${user}";
      value = { extraGroups = [ "video" ]; };
    }) cfg.users);

    environment.etc."xdg/startx/xinitrc" = {
      text = ''
        command -v feh && feh --no-fehbg --bg-fill /etc/xdg/backgrounds/background.jpg
        command -v polybar && polybar 2>&1 | tee -a /tmp/polybar.log &
        command -v autorandr && autorandr -c
        command -v xset && command -v xss-lock && xset s on ; xset s 3600 ; xss-lock systemctl suspend &

        # get picom service working, is there a better solution?
        systemctl --user import-environment XAUTHORITY DISPLAY
        systemctl --user restart picom.service

        exec xmonad
      '';
      mode = "0555";
    };
  };
}
