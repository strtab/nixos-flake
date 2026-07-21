{
  inputs,
  lib,
  config,
  ...
}:
{
  options.modules.nix = {
    substituters = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "https://cache.nixos.org?priority=10"
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
        "https://numtide.cachix.org"
      ];
    };
    trusted-public-keys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
      ];
    };
  };

  config = {
    services.envfs.enable = true; # Dynamic populates contents of /bin

    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.allowBroken = false;

    nix = {
      nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
      channel.enable = false; # We don't use channels, but we need to disable it to prevent it from trying to update the channel and failing because we don't have write access to /nix/var/nix/profiles/per-user/root/channels
      extraOptions = ''
        warn-dirty = false
      '';
      settings = {
        download-buffer-size = 262144000; # 250 MB (250 * 1024 * 1024)
        auto-optimise-store = true; # Automatically optimize the Nix store after garbage collection
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        substituters = config.modules.nix.substituters;
        trusted-public-keys = config.modules.nix.trusted-public-keys;
      };
    };
  };
}
