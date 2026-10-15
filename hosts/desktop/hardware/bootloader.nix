{
  boot = {
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];

    initrd.availableKernelModules = [
      "xhci_pci"
      "ehci_pci"
      "ahci"
      "usb_storage"
      "sd_mod"
      "sr_mod"
      "rtsx_pci_sdmmc"
    ];

    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
        consoleMode = "auto";
      };
      efi.efiSysMountPoint = "/boot";
      timeout = 0;
    };

    kernel.sysctl = {
      "ipcs_shm" = 1; # enable shared memory segments for IPC (inter-process communication)
      "vm.nr_hugepages_defrag" = 0; # disable hugepage defragmentation to avoid OOM during boot
      "vm.compact_memory" = 0; # disable memory compaction (defragmentation) to avoid OOM during boot
      "transparent_hugepage" = "always"; # enable transparent hugepages for better performance
      "default_hugepagesz" = "1G"; # set default hugepages size to 1GB
      "hugepagesz" = "1G"; # set hugepage size to 1GB
    };

    kernelParams = [
      "rw" # read write

      "boot.shell_on_fail" # drop to shell on boot failure
      "nosoftlockup" # disable soft lockup detector

      "usbcore.autosuspend=-1"
      "usbcore.old_scheme_first=1"

      "skew_tick=1" # enable skewed ticks
      "preempt=full" # enable full preemption (low latency)

      "video=HDMI-A-1:1920x1080@75"
      "video=LVDS-1:d" # disable monitor
    ];
  };
}
