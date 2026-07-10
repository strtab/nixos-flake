{ pkgs, ... }:
{
  home.packages = with pkgs; [
    roslyn-ls
  ];
  programs.neovim = {
    enable = true;
  };
}
