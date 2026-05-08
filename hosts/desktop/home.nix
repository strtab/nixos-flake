{ config, ... }:
{
  imports = [
    ./variables.nix

    # Shell
    ../../home/shell
    ../../home/shell/zsh.nix

    # System
    ../../home/system/illogical-impulce.nix
  ];

  home = {
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;
    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;
}
