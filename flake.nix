{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    import-tree.url = "github:denful/import-tree";
    agenix.url = "github:ryantm/agenix"; 

    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "github:nix-community/nix-index-database";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # DNS block lists
    hagezi_pro.url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/pro.plus-onlydomains.txt";
    hagezi_pro.flake = false;
    hagezi_piracy.url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/anti.piracy-onlydomains.txt";
    hagezi_piracy.flake = false;

    # Browser
    helium.url = "github:amaanq/helium-flake";
    helium.inputs.nixpkgs.follows = "nixpkgs";

    # Hyprland
    hyprland.url = "github:hyprwm/Hyprland?ref=v0.56.1";
    hyblock.url = "github:strtab/hyblock?ref=v0.56.1";
    hyblock.inputs.hyprland.follows = "hyprland";
    # hypr-dynamic-cursors.url = "github:VirtCode/hypr-dynamic-cursors/da447486c84e0be81f2cdd208af1ef92469f0a88";
    # hypr-dynamic-cursors.inputs.hyprland.follows = "hyprland";

    # Kde Theme
    geist.url = "github:strtab/Plasma-Geist-visual-style";
    geist.flake = false;

    aether.url = "github:strtab/aether";
    aether.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      nixpkgs,
      nixpkgs-master,
      nixpkgs-unstable,
      import-tree,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-master = import nixpkgs-master {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.moonveil = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit
            inputs
            nixpkgs
            system
            pkgs-unstable
            pkgs-master
            ;
        };
        modules = [
          { _module.args = { inherit inputs; }; }
          inputs.nix-index-database.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
          inputs.agenix.nixosModules.default
          ./hosts/desktop/configuration.nix
        ];
      };
    };
}
