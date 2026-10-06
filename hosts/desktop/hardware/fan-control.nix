{ config, pkgs, ... }:
let
  # Prints GPU temperature in millidegrees.
  # On failure prints 50000.
  gpuTemp = pkgs.writeShellScript "gpu-temp-millic" ''
    t=$(${config.hardware.nvidia.package.bin}/bin/nvidia-smi \
          --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null | head -n1)
    case "$t" in
      ""|*[!0-9]*) echo 50000 ;;
      *) echo $(( t * 1000 )) ;;
    esac
  '';

  maxTemp = pkgs.writeShellScript "max-temp-millic" ''
    cpu=$(cat /sys/class/hwmon/hwmon0/temp1_input)
    gpu=$(${gpuTemp})
    [ "$cpu" -gt "$gpu" ] && echo "$cpu" || echo "$gpu"
  '';
in
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

      FCTEMPS=hwmon1/pwm2=!${maxTemp} hwmon1/pwm3=!${maxTemp}
      FCFANS=hwmon1/pwm2=hwmon1/fan2_input hwmon1/pwm3=hwmon1/fan3_input

      MINTEMP=hwmon1/pwm2=35 hwmon1/pwm3=35
      MAXTEMP=hwmon1/pwm2=65 hwmon1/pwm3=65

      INTERVAL=5

      MAXPWM=hwmon1/pwm2=220 hwmon1/pwm3=220

      MINSTART=hwmon1/pwm2=70 hwmon1/pwm3=70
      MINSTOP=hwmon1/pwm2=60 hwmon1/pwm3=60
    '';
  };
}
