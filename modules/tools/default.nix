{ config, lib, pkgs, pkgs-unstable, ... }:
with lib;
let
  cfg = config.modules.tools;
in
{
  options = {
    modules.tools = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };

  config = mkIf cfg.enable {
    programs.fzf = {
      fuzzyCompletion = true;
      keybindings = true;
    };

    environment.systemPackages = with pkgs; [
      bat
      bc
      bottom
      csvtool
      dnsutils
      fd
      file
      findutils
      glow
      go-grip
      jq
      pkgs-unstable.neovim
      ripgrep
      tealdeer
      tmux
      tree
      unzip
      vim
    ];
  };
}
