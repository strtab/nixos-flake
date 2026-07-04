{ ... }:
{
  home.sessionVariables = {
    MAILDIR = "$HOME/.local/mail/";
  };
  imports = [
    ./aerc.nix
    ./mbsync.nix
    ./notmuch.nix
    ./goimapnotify.nix
  ];
}
