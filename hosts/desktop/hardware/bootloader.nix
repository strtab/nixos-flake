{
  boot.initrd.kernelModules = [ "i915" ];
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "auto";
        editor = false;
      };
      efi.efiSysMountPoint = "/boot";
      timeout = 0;
    };
    kernel.sysctl = {
      "ipcs_shm" = 1; # enable shared memory segments for IPC (inter-process communication)
      "vm.nr_hugepages_defrag" = 0; # disable hugepage defragmentation to avoid OOM during boot
      "vm.compact_memory" = 0; # disable memory compaction (defragmentation) to avoid OOM during boot
      "transparent_hugepage" = "always"; # enable transparent hugepages for better performance
      "default_hugepagez" = "1G"; # set default hugepage size to 1GB
      "hugepagesz" = "1G"; # set hugepage size to 1GB
    };
    kernelParams = [
      "rw" # read write

      "boot.shell_on_fail" # drop to shell on boot failure

      "i915.fastboot=1" # enable fastboot for i915 driver
      "nowatchdog" # disable kernel watchdog 
      "nosoftlockup" # disable soft lockup detector
      "audit=0" # disable audit subsystem 
      "skew_tick=1" # enable skewed ticks 
      "threadirqs" # run kernel threads on the same cpu as the process that created them
      "preempt=full" # enable full preemption (low latency)
      "nohz_full=all" # enable full dynamic ticks 
      "mitigations=off" # disable cpu security 

      "video=HDMI-A-1:1920x1080@75"
      "video=LVDS-1:d" # disable monitor
    ];
  };
}
