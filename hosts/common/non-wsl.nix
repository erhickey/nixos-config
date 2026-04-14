{ hostname, locale, user, ... }:
{
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  i18n = {
    defaultLocale = "${locale}";

    extraLocaleSettings = {
      LC_ADDRESS = "${locale}";
      LC_IDENTIFICATION = "${locale}";
      LC_MEASUREMENT = "${locale}";
      LC_MONETARY = "${locale}";
      LC_NAME = "${locale}";
      LC_NUMERIC = "${locale}";
      LC_PAPER = "${locale}";
      LC_TELEPHONE = "${locale}";
      LC_TIME = "${locale}";
    };
  };

  networking = {
    networkmanager.enable = true;
    hostName = "${hostname}";
  };

  users.users.${user}.extraGroups = [ "networkmanager" "wheel" ];

  # configure printers: http://localhost:631
  services.printing.enable = true;

  # enable autodiscovery of network printers
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  modules.pipewire = {
    enable = true;
    users = [ "${user}" ];
  };
}
