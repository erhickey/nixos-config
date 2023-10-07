{ ... }:
{
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  modules.polybar.modules.battery = {
    adapter = "AC";
    battery = "BAT0";
  };
}
