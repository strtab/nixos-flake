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
    helium.url = "github:amaanq/helium-flake";
    helium.inputs.nixpkgs.follows = "nixpkgs";

    # Hyprland
    hyprland.url = "github:hyprwm/Hyprland/a0136d8c04687bb36eb8a28eb9d1ff92aea99704"; # v0.55.4
    hypr-dynamic-cursors.url = "github:VirtCode/hypr-dynamic-cursors/da447486c84e0be81f2cdd208af1ef92469f0a88";
    hypr-dynamic-cursors.inputs.hyprland.follows = "hyprland";

    # Kde Theme
    geist.url = "github:strtab/Plasma-Geist-visual-style";
    geist.flake = false;

    dotfiles.url = "gitlab:strtab/illogical-impulce-dots/4f308b4366f3f8d665ba76037be095a58541be52";
    dotfiles.flake = false;
    illogical-flake = {
      url = "gitlab:strtab/illogical-flake/910eba218abc31adab2e685233cd80e22e61b823";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.dotfiles.follows = "dotfiles";
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
