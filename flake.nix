{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, unstable, ... }@inputs:
  let
    lib = nixpkgs.lib;

    stateVersion = "23.05";

    oss = [
      { os = "linux"; }
    ];

    hosts = [
      {
        host = "pavilion-g7";
        arch = "x86_64";
      }
      {
        host = "hp-notebook-14";
        arch = "x86_64";
      }
      {
        host = "thinkpad-e15";
        arch = "x86_64";
      }
    ];

    contexts = [
      {
        context = "personal";
        user = "eddie";
        hostname = "home";
        timezone = "America/New_York";
        locale = "en_US.UTF-8";
        defaultBrowser = "firefox.desktop";
      }
      {
        context = "rivet";
        user = "eddie";
        hostname = "rivet";
        timezone = "America/New_York";
        locale = "en_US.UTF-8";
        defaultBrowser = "firefox.desktop";
      }
    ];

    configPermutations = lib.concatMap
      (oh: map (context: context // oh) contexts)
      (lib.concatMap (os: map (host: host // os) hosts) oss);

    listdirs = import ./util/listdirs.nix { lib = lib; };
  in
  {
    nixosConfigurations = builtins.listToAttrs (map (p:
      let
        system = "${p.arch}-${p.os}";
      in
      with p; {
        name = "${context}-${host}-${os}";
        value = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit
              context
              defaultBrowser
              host
              hostname
              inputs
              lib
              listdirs
              locale
              nixpkgs
              stateVersion
              system
              timezone
              unstable
              user
            ;
          };
          modules = [
            ./overlays
            ./modules
            ./hosts
            ./contexts
          ];
        };
      }
    ) configPermutations );
  };
}
