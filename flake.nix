{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";
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

    jakubkrehel-skills.url = "github:jakubkrehel/skills";
    jakubkrehel-skills.flake = false;
    obsidian-skills.url = "github:kepano/obsidian-skills";
    obsidian-skills.flake = false;
    ponytail-skills.url = "github:DietrichGebert/ponytail";
    ponytail-skills.flake = false;

    # Coding agent
    pi-hm.url = "github:strtab/pi-hm";
    pi-hm.inputs.nixpkgs.follows = "nixpkgs";

    # Kde Theme
    geist.url = "github:strtab/Plasma-Geist-visual-style";
    geist.flake = false;

    aether.url = "github:strtab/aether";
    aether.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      nixpkgs,
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
