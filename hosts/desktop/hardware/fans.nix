{ pkgs, ... }:
{
  boot.kernelModules = [
    "it87"
    "coretemp"
  ];

  environment.systemPackages = with pkgs; [ lm_sensors ];

  hardware.fancontrol = {
    enable = true;
  };
}
