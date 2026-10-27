{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.modules.nix.nh = {
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
    environment.systemPackages = [
      (pkgs.nh.override {
        nix-output-monitor = pkgs.nix-output-monitor.overrideAttrs (old: {
          postPatch = old.postPatch or "" + ''
            substituteInPlace lib/NOM/Print.hs \
              --replace 'down = "↓"' 'down = "\xf072e"' \
              --replace 'up = "↑"' 'up = "\xf0737"' \
              --replace 'clock = "⏱"' 'clock = ""' \
              --replace 'running = "⏵"' 'running = "\xf04b"' \
              --replace 'done = "✔"' 'done = "\xf00c"' \
              --replace 'todo = "⏸"' 'todo = "\xf04d"' \
              --replace 'warning = "⚠"' 'warning = "\xf071"' \
              --replace 'average = "∅"' 'average = "\xf1da"' \
              --replace 'bigsum = "∑"' 'bigsum = "\xf04a0"'
          '';
        });
      })
    ];

    programs.nh = {
      enable = config.modules.nix.nh.enable;
      clean.enable = config.modules.nix.nh.clean.enable;
      clean.extraArgs = config.modules.nix.nh.clean.extraArgs;
      flake = config.modules.nix.nh.flakePath;
    };
  };
}
