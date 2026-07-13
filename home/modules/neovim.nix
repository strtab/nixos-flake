{ pkgs, ... }:
{
  home.packages = with pkgs; [
    roslyn-ls # csharp lsp
    nil # nix lsp
    neovim
  ];
  # programs.neovim = {
  #   enable = true;
  # };
}
