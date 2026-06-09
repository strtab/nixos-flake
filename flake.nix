{
  # https://github.com/strtab/nix-flake
  description = ''
    My nixos flake.
  '';

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland
    hyprland.url = "github:hyprwm/Hyprland/39d7e209c79d451efab1b21151d5938289da838d"; # v0.55.2
    hypr-dynamic-cursors = {
      url = "github:VirtCode/hypr-dynamic-cursors/da447486c84e0be81f2cdd208af1ef92469f0a88";
      inputs.hyprland.follows = "hyprland";
    };

    # Shell
    dotfiles = {
      url = "gitlab:strtab/illogical-impulce-dots/5809a38c5034a7a116cee73be2d6f615416b5aa4";
      flake = false;
    };
    illogical-flake = {
      url = "gitlab:strtab/illogical-flake/7b1589cda1176c3f2129c7e725871a6fb6503893";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.dotfiles.follows = "dotfiles";
    };
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    {
      nixosConfigurations.moonveil = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          { _module.args = { inherit inputs; }; }
          inputs.nix-index-database.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
          ./hosts/desktop/configuration.nix
        ];
      };
    };
}
