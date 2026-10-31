{
  boot = {
    plymouth = {
      enable = true;
    };

    consoleLogLevel = 3;
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];

    initrd = {
      kernelModules = [ ];
      availableKernelModules = [
        "xhci_pci"
        "ehci_pci"
        "ahci"
        "usb_storage"
        "sd_mod"
        "sr_mod"
        "rtsx_pci_sdmmc"
      ];
    };

    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
        consoleMode = "auto";
      };
      efi.efiSysMountPoint = "/boot";
      timeout = 0;
    };

    kernelParams = [
      "rw" # read write

      "quiet"
      "rd.udev.log_level=3"
      "rd.systemd.show_status=auto"
      "loglevel=3"

      "boot.shell_on_fail" # drop to shell on boot failure
      "nosoftlockup" # disable soft lockup detector

      "vm.nr_hugepages_defrag=0" # disable hugepage defragmentation to avoid OOM during boot
      "transparent_hugepage=always" # enable transparent hugepages for better performance
      "hugepagesz=1G" # set hugepage size to 1GB

      "usbcore.autosuspend=-1"

      "preempt=full" # enable full preemption (low latency)

      "video=HDMI-A-1:1920x1080@75"
      "video=LVDS-1:d" # disable monitor
    ];
  };
}
