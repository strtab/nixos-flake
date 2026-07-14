{ pkgs, lib, config, ... }:
{
  home.packages = with pkgs; [
    neovim

    bash-language-server
    yaml-language-server
    lua-language-server
    gopls # golang lsp
    roslyn-ls # csharp lsp
    nixfmt # nix formatter
    nil # nix lsp
  ];
  home.activation.cloneNeovimDots = lib.hm.dag.entryAfter ["writeBoundary"] ''
  if [ ! -d "${config.home.homeDirectory}/.config/nvim" ]; then
    $DRY_RUN_CMD ${pkgs.git}/bin/git clone --depth 1 --recursive $VERBOSE_ARG \
      https://github.com/strtab/nvim-config.git "${config.home.homeDirectory}/.config/nvim"
  fi
'';
}
