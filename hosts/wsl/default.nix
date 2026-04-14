{ user, ... }:
{
  wsl.enable = true;
  wsl.defaultUser = "${user}";
  wsl.interop.includePath = false;

  environment.sessionVariables.COLORTERM = "truecolor";
}
