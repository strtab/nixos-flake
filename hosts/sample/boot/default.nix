{
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
        consoleMode = "auto";
      };
      efi.efiSysMountPoint = "/boot";
    };
    kernelParams = [
      "rw" # read write
    ];
  };
}
