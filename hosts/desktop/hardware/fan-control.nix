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
      DEVPATH=hwmon0=devices/platform/coretemp.0 hwmon1=devices/platform/it87.2608
      DEVNAME=hwmon0=coretemp hwmon1=it8772

      FCTEMPS=hwmon1/pwm2=hwmon0/temp1_input hwmon1/pwm3=hwmon0/temp1_input
      FCFANS=hwmon1/pwm2=hwmon1/fan2_input hwmon1/pwm3=hwmon1/fan3_input

      MINTEMP=hwmon1/pwm2=35 hwmon1/pwm3=35
      MAXTEMP=hwmon1/pwm2=55 hwmon1/pwm3=55

      INTERVAL=10

      MAXPWM=hwmon1/pwm2=200 hwmon1/pwm3=200

      MINSTART=hwmon1/pwm2=60 hwmon1/pwm3=60
      MINSTOP=hwmon1/pwm2=50 hwmon1/pwm3=50
    '';
  };
}
