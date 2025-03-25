{ defaultBrowser, hostname, locale, pkgs, timezone, user, ... }:
{
  time.timeZone = "${timezone}";

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

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "LiberationMono" ]; })
  ];

  users.users.${user} = {
    isNormalUser = true;
    shell = pkgs.bash;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  xdg.mime = {
    enable = true;

    defaultApplications = {
      "text/html" = "${defaultBrowser}";
      "x-scheme-handler/http" = "${defaultBrowser}";
      "x-scheme-handler/https" = "${defaultBrowser}";
      "x-scheme-handler/about" = "${defaultBrowser}";
      "x-scheme-handler/unknown" = "${defaultBrowser}";
    };
  };

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

  modules.x = {
    enable = true;
    users = [ "${user}" ];
  };
}
