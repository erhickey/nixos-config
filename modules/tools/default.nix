{ config, lib, pkgs, ... }:
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
      dnsutils
      fd
      file
      findutils
      glow
      jq
      neovim
      ripgrep
      tealdeer
      tmux
      tree
      vim
    ];
  };
}
