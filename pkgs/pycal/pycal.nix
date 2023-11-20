{ pkgs, ... }:
with pkgs; stdenv.mkDerivation {
  name = "pycal";
  version = "0.1";

  propagatedBuildInputs = [
    (python310.withPackages (pythonPackages: with pythonPackages; [
      arrow
      docopt
      icalendar
      recurring-ical-events
      schema
    ]))
  ];

  dontUnpack = true;
  installPhase = "install -Dm755 ${./pycal.py} $out/bin/pycal";
}
