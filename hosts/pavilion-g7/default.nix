{  ... }:
{
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  modules.polybar.modules.battery = {
    adapter = "ACAD";
    battery = "BAT0";
  };
}
