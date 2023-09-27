{ config, lib, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ../common
    ];

  networking.hostName = "hp-laptop";

  environment.systemPackages = with pkgs; [
    xorg.xf86videoamdgpu
  ];
}
