{ config, ... }:
{
  imports = [
    ./variables.nix

    ../../home
    ../../home/shell/zsh.nix
  ];

  home = {
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;
    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;
}
