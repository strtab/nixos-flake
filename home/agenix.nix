{
  lib,
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.agenix.homeManagerModules.default
  ];

  # We use a separate SSH key for agenix decryption to avoid exposing the main
  # private key (which is in 1Password) to the filesystem.
  #
  # To provision this key once:
  #   ssh-keygen -t ed25519 -f ~/.ssh/agenix
  age = {
    identityPaths = [ "${config.home.homeDirectory}/.ssh/agenix" ];
    secrets = {
      # email
      goimapnotify.file = "${inputs.self}/secrets/mail/goimapnotify.age";
      aerc-accounts.file = "${inputs.self}/secrets/mail/aerc-accounts.age";
      isyncrc.file = "${inputs.self}/secrets/mail/isyncrc.age";
      notmuch.file = "${inputs.self}/secrets/mail/notmuch.age";
    };
  };
}
