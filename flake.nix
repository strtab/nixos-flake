{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";

    import-tree.url = "github:denful/import-tree"; # Importing all modules from a directory
    agenix.url = "github:ryantm/agenix"; # Secrets

    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "github:nix-community/nix-index-database";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Browser
    helium.url = "github:amaanq/helium-flake/0bf1ab5b25bb9ca10ea21b3124825f89da520c5d"; # v0.17.1.1
    helium.inputs.nixpkgs.follows = "nixpkgs";

    # Hyprland
    hyprland.url = "github:hyprwm/Hyprland/5c9377c15f85c50648f35ca5a213754f95b93ca0"; # v0.56.1
    # hypr-dynamic-cursors.url = "github:VirtCode/hypr-dynamic-cursors/da447486c84e0be81f2cdd208af1ef92469f0a88";
    # hypr-dynamic-cursors.inputs.hyprland.follows = "hyprland";

    # Kde Theme
    geist.url = "github:strtab/Plasma-Geist-visual-style";
    geist.flake = false;

    aether = {
      url = "github:strtab/aether";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, import-tree, ... }:
    {
      nixosConfigurations.moonveil = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
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
