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
    cpu=$(cat /sys/class/hwmon/hwmon1/temp1_input)
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
      DEVPATH=hwmon1=devices/platform/coretemp.0 hwmon2=devices/platform/it87.2608
      DEVNAME=hwmon1=coretemp hwmon2=it8772

      FCTEMPS=hwmon2/pwm2=!${maxTemp} hwmon2/pwm3=!${maxTemp}
      FCFANS=hwmon2/pwm2=hwmon2/fan2_input hwmon2/pwm3=hwmon2/fan3_input

      MINTEMP=hwmon2/pwm2=35 hwmon2/pwm3=35
      MAXTEMP=hwmon2/pwm2=65 hwmon2/pwm3=65

      INTERVAL=5

      MAXPWM=hwmon2/pwm2=220 hwmon2/pwm3=220

      MINPWM=hwmon2/pwm2=60 hwmon2/pwm3=60
      MINSTART=hwmon2/pwm2=70 hwmon2/pwm3=70
      MINSTOP=hwmon2/pwm2=60 hwmon2/pwm3=60
    '';
  };
}
