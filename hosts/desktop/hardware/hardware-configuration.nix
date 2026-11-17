{
  config,
  pkgs,
  lib,
  ...
}:
{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/b75edf87-d2e8-40f6-9128-ff5053bc1b71";
    fsType = "btrfs";
    options = [
      "subvol=@"
      "compress=zstd:1"
      "noatime"
    ];
  };
  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/b75edf87-d2e8-40f6-9128-ff5053bc1b71";
    fsType = "btrfs";
    options = [
      "subvol=@log"
      "compress=zstd:1"
      "noatime"
    ];
    neededForBoot = true;
  };
  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/b75edf87-d2e8-40f6-9128-ff5053bc1b71";
    fsType = "btrfs";
    options = [
      "subvol=@nix"
      "compress=zstd:1"
      "noatime"
    ];
  };
  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/b75edf87-d2e8-40f6-9128-ff5053bc1b71";
    fsType = "btrfs";
    options = [
      "subvol=@home"
      "compress=zstd:1"
      "noatime"
    ];
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/FABA-A61A";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  fileSystems."/mnt/sdb" = {
    device = "/dev/disk/by-uuid/bc980c10-7385-48ad-8040-cb251fde73c5";
    fsType = "ext4";
    options = [
      "nofail"
      "x-systemd.automount"
      "x-systemd.idle-timeout=100"
      "x-systemd.mount-timeout=15"
    ];
  };

  systemd.services.chmod-mnt-sdb = {
    description = "Set permissions for /mnt/sdb to allow all users access";
    after = [ "mnt-sdb.mount" ];
    requires = [ "mnt-sdb.mount" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      chown root:users /mnt/sdb
      chmod 775 /mnt/sdb
    '';
  };

  environment.systemPackages = [ pkgs.sshfs ];
  fileSystems."/mnt/homelab" = {
    device = "user@homelab.lan:/mnt/raid1/share";
    fsType = "sshfs";
    options = [
      "nodev"
      "noatime"
      "allow_other"
      "_netdev"
      "nofail"
      "reconnect"
      "follow_symlinks"
      "x-systemd.automount"
      "x-systemd.idle-timeout=600"
      "x-systemd.mount-timeout=15"
      "ServerAliveInterval=15"
      "StrictHostKeyChecking=accept-new"
      "IdentityFile=/home/user/.ssh/id_ed25519"
      "UserKnownHostsFile=/home/user/.ssh/known_hosts"
    ];
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
