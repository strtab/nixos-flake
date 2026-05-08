{
  home.sessionPath = [
    "$HOME/.nix-profile/bin"
    "$HOME/.go/bin"
    ".venv/bin"
    "$HOME/.local/bin"
    "$HOME/.npm-global/bin"
  ];

  home.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = "1";
    GOPATH = "$HOME/.go";
    EDITOR = "nvim";
  };
}
