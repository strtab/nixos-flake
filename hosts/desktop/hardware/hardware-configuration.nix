{
  config,
  pkgs,
  lib,
  ...
}:

{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/45d1a8f4-f94d-4efc-9b8a-6d18a5e14c90";
    fsType = "f2fs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1AAE-82ED";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/2b9ea38c-974d-4774-ac21-b34aabf90ac1";
    fsType = "f2fs";
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

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 20 * 1024;
    }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
