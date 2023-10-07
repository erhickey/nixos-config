{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.gnupg;
in
{
  # Example gnupg usage:
  # - create gnupg user:
  #   mkdir ~/.gnupg
  #   chmod 600 ~/.gnupg
  #   gpg --full-gen-key
  # - create gpg file with some contents:
  #   1. run following command
  #     gpg --encrypt -o ~/.gnupg/{filename}.gpg -r {username}
  #   2. enter contents on stdin
  #   3. press enter
  #   4. press ctrl + d

  options = {
    modules.gnupg = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
    programs.gnupg.agent = {
      enable = true;
      pinentryFlavor = "curses";
    };

    environment.systemPackages = with pkgs; [
      pinentry.curses
    ];
  };
}
