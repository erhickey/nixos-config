{ hostname, locale, pkgs, timezone, user, ... }:
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

  networking.hostName = "${hostname}";

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "LiberationMono" ]; })
  ];

  users.users.${user} = {
    isNormalUser = true;
    shell = pkgs.bash;
    extraGroups = [ "wheel" ];
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
