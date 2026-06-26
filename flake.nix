{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";

    import-tree.url = "github:denful/import-tree"; # Importing all modules from a directory
    agenix.url = "github:ryantm/agenix"; # Secrets

    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "github:nix-community/nix-index-database";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Hyprland
    hyprland.url = "github:hyprwm/Hyprland/39d7e209c79d451efab1b21151d5938289da838d"; # v0.55.2
    hypr-dynamic-cursors.url = "github:VirtCode/hypr-dynamic-cursors/da447486c84e0be81f2cdd208af1ef92469f0a88";
    hypr-dynamic-cursors.inputs.hyprland.follows = "hyprland";

    dotfiles.url = "gitlab:strtab/illogical-impulce-dots/5809a38c5034a7a116cee73be2d6f615416b5aa4";
    dotfiles.flake = false;
    illogical-flake = {
      url = "gitlab:strtab/illogical-flake/7b1589cda1176c3f2129c7e725871a6fb6503893";
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
