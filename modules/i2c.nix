# This module needed for access all devices on an adapters
# (ecpecially for brightness control on external monitors).
# https://www.kernel.org/doc/html/v5.4/i2c/dev-interface.html
{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.i2c = {
    enable = lib.mkEnableOption "Enable access all devices on an adapter from userspace" // {
      default = true;
    };
  };
  config = lib.mkIf config.i2c.enable {
    users.users."${config.var.username}".extraGroups = [ "i2c" ];
    boot = {
      extraModulePackages = [ config.boot.kernelPackages.ddcci-driver ];
      kernelModules = [
        "i2c_dev"
        "ddcci_backlight"
      ];
    };

    hardware.i2c.enable = true;

    environment.systemPackages = with pkgs; [ i2c-tools ];

    # https://www.ddcutil.com/i2c_permissions/
    services.udev.extraRules = ''
      SUBSYSTEM=="i2c-dev", KERNEL=="i2c-[0-9]*", ATTRS{class}=="0x030000", TAG+="uaccess"
      SUBSYSTEM=="dri", KERNEL=="card[0-9]*", TAG+="uaccess"
    '';
  };
}
