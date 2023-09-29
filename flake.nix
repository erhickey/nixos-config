{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-23.05";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, ... }@attrs: {
    nixosConfigurations =
      let
        mkNixOSHost = name: system: nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = attrs;
          modules = [
            ./options.nix
            ./homemanager/${name}
            ./host/${name}
          ];
        };
      in {
        hp-notebook = mkNixOSHost "hp-notebook" "x86_64-linux";
        hp-laptop = mkNixOSHost "hp-laptop" "x86_64-linux";
        rivet-thinkpad = mkNixOSHost "rivet-thinkpad" "x86_64-linux";
      };
  };
}
