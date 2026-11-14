{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
{
  environment.systemPackages = [ inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default ];
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
      borg-keyfile = {
        file = "${inputs.self}/secrets/borgbackup/keyfile.age";
        owner = "${config.var.username}";
        group = "users";
        mode = "0400";
      };
      borg-passphrase = {
        file = "${inputs.self}/secrets/borgbackup/passphrase.age";
        owner = "${config.var.username}";
        group = "users";
        mode = "0400";
      };

      git-credentials = lib.mkIf config.var.git.useSecrets {
        file = "${inputs.self}/secrets/git-credentials.age";
        symlink = false; # copy file instead of use symlink
        path = "${config.home-manager.users.${config.var.username}.home.homeDirectory}/.git-credentials";
        owner = "${config.var.username}";
        group = "users";
        mode = "400";
      };
    };
  };
}
