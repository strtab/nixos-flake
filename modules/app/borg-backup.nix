{ config, lib, ... }:

let
  home = "/home/${config.var.username}";
  cfg = config.modules.borgbackup;
in
{
  options.modules.borgbackup = {
    enable = lib.mkEnableOption "Whether enable borgbackup";
    homedirs = {
      enable = lib.mkEnableOption "Whether enable home dirs backups" // {
        default = true;
      };
      repo = lib.mkOption {
        type = lib.types.str;
        default = "ssh://user@homelab.lan/mnt/raid1/share/borg";
        description = "Borg repository URL (absolute path on the server)";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.borgbackup.jobs.homedirs = lib.mkIf cfg.homedirs.enable {
      paths = [
        "${home}/Videos"
        "${home}/Pictures"
        "${home}/Music"
        "${home}/Documents"
        "${home}/Development"
      ];

      repo = cfg.homedirs.repo;

      # Run as the owner of the data and of the SSH key
      user = config.var.username;
      group = "users";

      environment = {
        # To get keyfile from repo: $ borg-job-homedirs key export :: ~/borg-keyfile.txt
        BORG_KEY_FILE = "${config.age.secrets.borg-keyfile.path}";
        BORG_RSH = builtins.concatStringsSep " " [
          "ssh"
          "-i ${home}/.ssh/id_ed25519"
          "-o IdentitiesOnly=yes"
          "-o BatchMode=yes"
          "-o ServerAliveInterval=15"
          "-o ServerAliveCountMax=4"
          "-o StrictHostKeyChecking=accept-new"
          "-o UserKnownHostsFile=${home}/.ssh/known_hosts"
        ];
      };

      # The unit runs with ProtectSystem=strict, known_hosts must be writable
      readWritePaths = [ "${home}/.ssh" ];

      encryption = {
        mode = "keyfile-blake2"; 
        passCommand = "cat ${config.age.secrets.borg-passphrase.path}";
      };

      # "auto" probes with lz4 first and stores incompressible data
      # (video, mp3, jpeg) as is, so it does not waste CPU on it.
      # zstd level 12: good ratio, still reasonably fast.
      compression = "auto,zstd,12";

      exclude = [
        "*/node_modules"
        "*/.direnv"
        "*/.cache"
        "*/target"
        "*/result"
        "*/.Trash-*"
      ];

      startAt = "daily";
      persistentTimer = true;
      inhibitsSleep = false;
      failOnWarnings = false;

      extraCreateArgs = [ "--stats" ];

      prune.keep = {
        daily = 7;
        weekly = 4;
        monthly = 6;
      };
    };
  };
}
