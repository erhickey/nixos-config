{ host, ... }:
{
  imports = [
    ./common
    ./${host}
  ] ++ (if host == "wsl" then [ ] else [ ./${host}/hardware-configuration.nix ]);
}
