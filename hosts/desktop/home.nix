{ config, inputs, ... }:
{
  imports = [
    ./variables.nix

    "${inputs.self}/home"
    "${inputs.self}/home/shell/zsh.nix"
  ];

  home = {
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;
    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;
}
