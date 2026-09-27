{ pkgs, ... }:
{
  boot.kernelModules = [
    "it87"
    "coretemp"
  ];

  environment.systemPackages = with pkgs; [ lm_sensors ];

  hardware.fancontrol = {
    enable = true;
    config = ''
      INTERVAL=10
      DEVPATH=hwmon0=devices/platform/coretemp.0 hwmon1=devices/platform/it87.2608
      DEVNAME=hwmon0=coretemp hwmon1=it8772
      FCTEMPS=hwmon1/pwm2=hwmon0/temp1_input hwmon1/pwm3=hwmon0/temp1_input
      FCFANS=hwmon1/pwm2=hwmon1/fan2_input hwmon1/pwm3=hwmon1/fan3_input
      MINTEMP=hwmon1/pwm2=30 hwmon1/pwm3=30
      MAXTEMP=hwmon1/pwm2=60 hwmon1/pwm3=60
      MINSTART=hwmon1/pwm2=35 hwmon1/pwm3=35
      MINSTOP=hwmon1/pwm2=0 hwmon1/pwm3=0
    '';
  };
}
