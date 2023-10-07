{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.dev;
in
{
  options = {
    modules.dev = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ghc
      git
      haskellPackages.haskell-language-server
      lua-language-server
      nil   # nix language server
      nodejs
      nodePackages.npm
      python3
      zig   # treesitter dependency
    ];
  };
}
