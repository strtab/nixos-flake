{ lib , config , ... }: {
  options.nix.nh = {
    enable = lib.mkEnableOption "Enable nh" // {
      default = true;
    };
    clean = {
      enable = lib.mkEnableOption "Enable nh clean";
      extraArgs = lib.mkOption {
        type = lib.types.str;
        default = "--keep-since 4d --keep 3";
      };
    };
    flakePath = lib.mkOption {
      type = lib.types.str;
      default = "/home/${config.var.username}/.flake";
      example = "/etc/nixos/";
    };
  };

  config = {
    programs.nh = {
      enable = config.nix.nh.enable;
      clean.enable = config.nix.nh.clean.enable;
      clean.extraArgs = config.nix.nh.clean.extraArgs;
      flake = config.nix.nh.flakePath;
    };
  };
}
