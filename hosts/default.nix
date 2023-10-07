{ host, ... }:
{
  imports = [
    ./common
    ./${host}/hardware-configuration.nix
    ./${host}
  ];
}
