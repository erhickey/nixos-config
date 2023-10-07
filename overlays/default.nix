{ listdirs, ... }:
{
  nixpkgs.overlays = map (d: import ./${d}) (listdirs ./.);
}
