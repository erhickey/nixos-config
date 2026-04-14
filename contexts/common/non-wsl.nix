{ defaultBrowser, pkgs, user, ... }:
{
  fonts.packages = with pkgs; [
    nerd-fonts.liberation
  ];

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

  modules.x = {
    enable = true;
    users = [ "${user}" ];
  };

  modules.autolockandsuspend.enable = true;
  modules.darkmode.enable = true;
  modules.polybar.enable = true;
}
