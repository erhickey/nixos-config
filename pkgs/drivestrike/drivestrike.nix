# POST INSTALL:
#   sudo drivestrike register REGISTRATION_KEY/EMAIL "" https://app.drivestrike.com/svc/
{ lib, pkgs, ... }:
let
  # to get version:
  # download install script:
  #   https://app.drivestrike.com/instructions/linux/
  # copy commands to register key and update apt repos
  # get locations of debian packages required to install:
  #   apt-get -y install --print-uris drivestrike | grep \.deb
  version = "2.1.22-31";

  src =
    if pkgs.stdenv.hostPlatform.system == "x86_64-linux" then
      pkgs.fetchurl {
        urls = [ "https://app.drivestrike.com/static/apt/pool/main/d/drivestrike/drivestrike_${version}_amd64.deb" ];
        sha256 = "sha256-blyXyt//0Pc28uHWZ4stsok9Se+y3JBL+lnSKnSCdgU=";
      }
    else
      throw "Drivestrike is not supported on ${pkgs.stdenv.hostPlatform.system}";
in with pkgs; stdenv.mkDerivation {
  pname = "drivestrike";
  inherit version;
  system = "x86_64-linux";
  inherit src;

  nativeBuildInputs = [ autoPatchelfHook wrapGAppsHook glib glib-networking makeWrapper ];

  buildInputs = [ dpkg libsoup dmidecode ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out
    dpkg -x $src $out
    cp -av $out/usr/* $out
    rm -rf $out/usr
    chmod -R g-w $out
  '';

  postFixup = ''
    wrapProgram $out/bin/drivestrike \
    --prefix PATH ":" "${lib.makeBinPath [ dmidecode ]}"
  '';
}
