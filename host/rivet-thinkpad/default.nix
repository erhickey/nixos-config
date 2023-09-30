{ config, lib, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ../common
    ];

  # Force use of the thinkpad_acpi driver for backlight control.
  # This allows the backlight save/load systemd service to work.
  # boot.kernelParams = [
  #   "acpi_backlight=native"
  # ];

  # acpi_call makes tlp work for newer thinkpads
  # boot = lib.mkIf config.services.tlp.enable {
  #   kernelModules = [ "acpi_call" ];
  #   extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
  # };

  networking.hostName = "rivet";

  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  virtualisation.docker.enable = true;

  networking.extraHosts = ''172.12.1.0 rivet'';

  services.autorandr = {
    enable = true;

    profiles = {
      "dual" = {
        fingerprint = {
          eDP = "00ffffffffffff0009e5e208000000002a1d0104a52213780300f5975e5b93291f505400000001010101010101010101010101010101993b8010713850403020360058c21000001a000000000000000000000000000000000000000000fe00424f452043510a202020202020000000fe004e5631353646484d2d4e34530a00db";
          HDMI-A-0 = "00ffffffffffff0004724c0666f69011131f010380351e78ca6c40a755519f27145054bfef80714f8140818081c081009500b300d1c0023a801871382d40582c45000f282100001e000000fd00384c1f5311000a202020202020000000fc004b41323431590a202020202020000000ff005442514141303031383538310a0121020322f14f90010203040506071112131415161f230907078301000065030c001000023a801871382d40582c45000f282100001e011d8018711c1620582c25000f282100009e011d007251d01e206e2855000f282100001e8c0ad08a20e02d10103e96000f282100001800000000000000000000000000000000000000000005";
        };
        config = {
          eDP = {
            enable = true;
            position = "0x1080";
            mode = "1920x1080";
            rate = "60.00";
          };
          HDMI-A-0 = {
            enable = true;
            primary = true;
            position = "0x0";
            mode = "1920x1080";
            rate = "60.00";
          };
        };
      };
      "single" = {
        fingerprint = {
          eDP = "00ffffffffffff0009e5e208000000002a1d0104a52213780300f5975e5b93291f505400000001010101010101010101010101010101993b8010713850403020360058c21000001a000000000000000000000000000000000000000000fe00424f452043510a202020202020000000fe004e5631353646484d2d4e34530a00db";
        };
        config = {
          eDP = {
            enable = true;
            primary = true;
            position = "0x0";
            mode = "1920x1080";
            rate = "60.00";
          };
        };
      };
    };
  };

  services.udev.extraRules = ''
    ACTION=="change", SUBSYSTEM=="drm", RUN+="${pkgs.autorandr}/bin/autorandr -c && feh --no-fehbg --bg-fill ~/.config/background.jpg"
  '';
}
