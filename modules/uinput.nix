# This module needed for creating and manage virtual input devices.
# https://www.kernel.org/doc/html/v4.12/input/uinput.html
{
  config,
  lib,
  ...
}:
{
  options.uinput = {
    enable = lib.mkEnableOption "Enable virtual input module" // {
      default = true;
    };
  };
  config = lib.mkIf config.uinput.enable {
    users.users."${config.var.username}".extraGroups = [ "uinput" ];
    hardware.uinput.enable = true;
  };
}
