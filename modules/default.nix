{ listdirs, ... }:
{
  imports = map (d: ./${d}) (listdirs ./.);
}
