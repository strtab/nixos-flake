{
  pkgs,
  lib,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    typescript-language-server
    bash-language-server
    yaml-language-server
    lua-language-server
    gopls # golang lsp
    nixfmt # nix formatter
    nixd # nix lsp
  ];
  programs.neovim = {
    withRuby = false;
    withPython3 = true;
    enable = true;
    sideloadInitLua = true;
    extraPackages = [
      pkgs.ueberzugpp
      pkgs.imagemagick
      pkgs.ghostscript # Required only when rendering PDF files
    ];
  };
  home.activation.cloneNeovimDots = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d "${config.home.homeDirectory}/.config/nvim" ]; then
      $DRY_RUN_CMD ${pkgs.git}/bin/git clone --depth 1 $VERBOSE_ARG \
        https://github.com/strtab/nvim-config.git "${config.home.homeDirectory}/.config/nvim"
    fi
  '';
}
