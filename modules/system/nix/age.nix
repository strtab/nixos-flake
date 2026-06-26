{ config, ... }:
{
  age = {
    # We use a separate SSH key for agenix decryption to avoid exposing the main
    # private key (which is in 1Password) to the filesystem.
    #
    # To provision this key once:
    #   ssh-keygen -t ed25519 -f ~/.ssh/agenix
    identityPaths = [
      "${config.home-manager.users.${config.var.username}.home.homeDirectory}/.ssh/agenix"
    ];
    secrets = {
      personal-password.file = ../../../secrets/mail/personal-password.age;
      work-password.file = ../../../secrets/mail/work-password.age;
      git-credentials = {
        file = ../../../secrets/git-credentials.age;
        mode = "400";
      };
    };
  };
}
