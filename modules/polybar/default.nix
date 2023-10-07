{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.polybar;
in
{
  options = {
    modules.polybar = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };

      colors = mkOption {
        type = types.lines;
        default = ''
          foreground = #A5A8A6
          background = #CC2A2A2A

          transparent = #00000000
          disabled = #7F8C8D

          red = #DC322F
          teal = #039494
          blue = 058DE8
        '';
      };

      settings = mkOption {
        type = types.lines;
        default = ''
          screenchange-reload = true
          pseudo-transparency = false
        '';
      };

      bar = mkOption {
        type = types.lines;
        default = ''
          width = 100%
          height = 20pt
          radius = 10

          background = ''${colors.background}
          foreground = ''${colors.foreground}

          line-size = 3pt

          border-top-size = 6pt
          border-bottom-size = 0
          border-left-size = 12pt
          border-right-size = 12pt
          border-color = ''${colors.transparent}

          padding-left = 0
          padding-right = 1

          module-margin = 1

          font-0 = LiterationMono Nerd Font:pixelsize=12:weight=bold;3
          font-1 = LiterationMono Nerd Font:pixelsize=15:weight=bold;2
          font-2 = LiterationMono Nerd Font:pixelsize=18:weight=bold;4

          cursor-click = pointer
          cursor-scroll = ns-resize
        '';
      };

      layout = mkOption {
        type = types.lines;
        default = ''
          modules-left = menu
          modules-right = audio wlan battery date
        '';
      };

      modules = {
        xworkspaces = {
          enable = mkOption {
            type = types.bool;
            default = false;
          };

          name = mkOption {
            type = types.str;
            default = "xworkspaces";
          };

          module = mkOption {
            type = types.lines;
            default = ''
              type = internal/xworkspaces

              ; only show workspaces on the same output as the bar
              pin-workspaces = true

              label-active = 󰐾
              label-active-padding = 1

              label-occupied = 
              label-occupied-padding = 1

              label-urgent = 
              label-urgent-foreground = ''${colors.red}
              label-urgent-padding = 1

              label-empty = 
              label-empty-foreground = ''${colors.disabled}
              label-empty-padding = 1
            '';
          };
        };

        audio = {
          enable = mkOption {
            type = types.bool;
            default = true;
          };

          name = mkOption {
            type = types.str;
            default = "audio";
          };

          module = mkOption {
            type = types.lines;
            default = ''
              type = internal/pulseaudio

              label-muted = 󰝟
              label-muted-font = 3
              format-volume = <ramp-volume>
              format-volume-font = 3

              ramp-volume-0 = 󰕿
              ramp-volume-1 = 󰖀
              ramp-volume-2 = 󰕾

              click-right = pavucontrol
            '';
          };
        };

        wlan = {
          enable = mkOption {
            type = types.bool;
            default = true;
          };

          name = mkOption {
            type = types.str;
            default = "wlan";
          };

          module = mkOption {
            type = types.lines;
            default = ''
              type = internal/network
              interval = 5
              format-connected = <label-connected>
              format-disconnected = <label-disconnected>

              interface-type = wireless
              label-connected = 󰖩
              label-connected-font = 2
              label-disconnected = "󰖪"
              label-disconnected-font = 2
            '';
          };
        };

        eth = {
          enable = mkOption {
            type = types.bool;
            default = false;
          };

          name = mkOption {
            type = types.str;
            default = "eth";
          };

          module = mkOption {
            type = types.lines;
            default = ''
              type = internal/network
              interval = 5
              format-connected = <label-connected>
              format-disconnected = <label-disconnected>

              interface-type = wired
              label-connected = 󰈁
              label-connected-font = 2
              label-disconnected = "󰈂"
              label-disconnected-font = 2
            '';
          };
        };

        date = {
          enable = mkOption {
            type = types.bool;
            default = true;
          };

          name = mkOption {
            type = types.str;
            default = "date";
          };

          module = mkOption {
            type = types.lines;
            default = ''
              type = internal/date
              interval = 5

              date = %b %d %H:%M
              label = "%date%"
            '';
          };
        };

        menu = {
          enable = mkOption {
            type = types.bool;
            default = true;
          };

          name = mkOption {
            type = types.str;
            default = "menu";
          };

          module = mkOption {
            type = types.lines;
            default = ''
              type = custom/menu
              expand-right = true

              label-open = " "
              label-open-font = 2
              label-open-foreground = ''${colors.blue}
              label-open-padding-left = 1
              label-close = 
              label-close-font = 2
              label-close-foreground = ''${colors.blue}
              label-close-padding-left = 1
              label-separator = |
              label-separator-foreground = ''${colors.blue}
              format-spacing = 1

              menu-0-0 = Utilities
              menu-0-0-exec = #menu.open.1
              menu-0-1 = Power
              menu-0-1-exec = #menu.open.2

              menu-2-0 = Reboot
              menu-2-0-exec = systemctl reboot
              menu-2-1 = Shutdown
              menu-2-1-exec = systemctl poweroff

              menu-1-0 = Bottom
              menu-1-0-exec = st btm
            '';
          };
        };

        mail = {
          enable = mkOption {
            type = types.bool;
            default = false;
          };

          name = mkOption {
            type = types.str;
            default = "mail";
          };

          script = mkOption {
            type = types.lines;
            default = ''
              #!/usr/bin/env bash

              mail_dir="$1"
              new=0

              if [ -d "$mail_dir" ] ; then
                for d in "$mail_dir"/*/new ; do
                  new="$(("$new" + "$(find "$d" -type f | wc -l)"))"
                done
              fi

              [ "$new" -gt 0 ] && echo "" || echo ""
            '';
          };

          module = mkOption {
            type = types.lines;
            default = ''
              type = custom/script
              interval = 3

              exec = /etc/xdg/polybar/mail.sh "$HOME/.mail/[Gmail]"

              click-left = st neomutt

              format = <label>
              format-foreground = ''${colors.teal}
              format-padding = 1
            '';
          };
        };

        bluetooth = {
          enable = mkOption {
            type = types.bool;
            default = false;
          };

          name = mkOption {
            type = types.str;
            default = "bluetooth";
          };

          module = mkOption {
            type = types.lines;
            default = ''
              type = custom/script
              interval = 5

              exec = bluetoothctl show 2> /dev/null | grep 'Powered: yes' > /dev/null && echo '󰂯' || echo '󰂲'

              click-left = blueberry
              click-right = bluetoothctl show 2> /dev/null | grep 'Powered: yes' > /dev/null && bluetoothctl power off || bluetoothctl power on

              format-font = 2
            '';
          };
        };

        battery = {
          enable = mkOption {
            type = types.bool;
            default = true;
          };

          name = mkOption {
            type = types.str;
            default = "battery";
          };

          battery = mkOption {
            type = types.str;
            default = "";
            example = "BAT0";
            description = lib.mdDoc ''
              Use the following command to list batteries and adapters:
              $ ls -1 /sys/class/power_supply/
            '';
          };

          adapter = mkOption {
            type = types.str;
            default = "";
            example = "ACAD";
            description = lib.mdDoc ''
              Use the following command to list batteries and adapters:
              $ ls -1 /sys/class/power_supply/
            '';
          };

          module = mkOption {
            type = types.lines;
            default = ''
              type = internal/battery

              ; This is useful in case the battery never reports 100% charge
              full-at = 99

              poll-interval = 5

              label-full = 󰁹
              label-full-font = 2

              format-charging = 󰂄
              format-charging-font = 2
              format-discharging = <ramp-capacity>
              format-discharging-font = 2

              ramp-capacity-0 = 󰂎
              ramp-capacity-1 = 󰁺
              ramp-capacity-2 = 󰁻
              ramp-capacity-3 = 󰁼
              ramp-capacity-4 = 󰁽
              ramp-capacity-5 = 󰁾
              ramp-capacity-6 = 󰁿
              ramp-capacity-7 = 󰂀
              ramp-capacity-8 = 󰂁
              ramp-capacity-9 = 󰂂

              ramp-capacity-0-foreground = ''${colors.red}
              ramp-capacity-1-foreground = ''${colors.red}
              ramp-capacity-2-foreground = ''${colors.red}
              ramp-capacity-9-foreground = ''${colors.red}
            '';
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
        polybar
      ];

      etc."xdg/polybar/config.ini" = {
        text = lib.strings.concatStringsSep "\n" (lib.lists.flatten ([
          "[colors]"
          cfg.colors
          "[settings]"
          cfg.settings
          "[bar/mybar]"
          cfg.bar
          cfg.layout

          (lib.trivial.pipe cfg.modules [
            (lib.attrsets.mapAttrsToList (name: value: { name = name; value = value; }))
            (lib.filter (m: m.value.enable && m.value.name != "battery"))
            (map (m: [ "[module/${m.value.name}]" m.value.module ]))
          ])

          (if cfg.modules.battery.enable then (lib.strings.concatStringsSep "\n" [
            "[module/${cfg.modules.battery.name}]"
            cfg.modules.battery.module
            "battery = ${cfg.modules.battery.battery}"
            "adapter = ${cfg.modules.battery.adapter}"
          ]) else "")
        ]));

        mode = "0444";
      };

      etc."xdg/polybar/mail.sh" = {
        text = cfg.modules.mail.script;
        mode = "0555";
      };
    };
  };
}
