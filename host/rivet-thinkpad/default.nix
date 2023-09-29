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
}
