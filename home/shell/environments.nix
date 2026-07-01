{
  home.sessionPath = [
    "$HOME/.nix-profile/bin"
    "$HOME/.go/bin"
    ".venv/bin"
    "$HOME/.local/bin"
    "$HOME/.local/state/npm/bin"
  ];

  home.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = "1";
    EDITOR = "nvim";
  };
}
