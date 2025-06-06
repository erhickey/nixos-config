{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.pipewire;
in
{
  options = {
    modules.pipewire = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };

      users = mkOption {
        type = types.listOf types.str;
        default = [];
        description = lib.mdDoc ''
          Users to add to audio group
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      alsa-utils
      pavucontrol
    ];

    services.pulseaudio.enable = false;
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;

      extraConfig.pipewire = {
       "10-echo-cancel.conf" = {
        "context.modules" = [
          {
            "name" = "libpipewire-module-echo-cancel";
            "args" = {
              "capture.props" = {
                "node.name" = "Echo Cancellation Capture";
              };
              "source.props" = {
                 "node.name" = "Echo Cancellation Source";
              };
              "sink.props" = {
                 "node.name" = "Echo Cancellation Sink";
              };
              "playback.props" = {
                 "node.name" = "Echo Cancellation Playback";
              };
            };
          }
        ];
       };
      };
    };

    users.users = builtins.listToAttrs (map (user: {
      name = "${user}";
      value = { extraGroups = [ "audio" ]; };
    }) cfg.users);
  };
}
