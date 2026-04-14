{ host, pkgs, user, ... }:
{
  users.users.${user} = {
    isNormalUser = true;
    shell = pkgs.bash;
  };

  imports = if host == "wsl" then [ ] else [ ./non-wsl.nix ];
}
