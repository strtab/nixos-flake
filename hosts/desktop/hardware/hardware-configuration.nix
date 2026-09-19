{
  config,
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

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 20 * 1024;
    }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
