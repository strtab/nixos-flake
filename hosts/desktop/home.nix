{ config, ... }:
{
  imports = [
    ./variables.nix

    # Shell
    ../../home/shell
    ../../home/shell/zsh.nix

    ../../home/modules/direnv.nix
    ../../home/modules/neomutt.nix
    ../../home/modules/hyprland.nix
  ];

  home = {
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;
    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;
}
