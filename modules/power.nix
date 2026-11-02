{ ... }:
{
  services = {
    upower.enable = true;
    thermald.enable = true;
    power-profiles-daemon.enable = true;
  };

  services.logind.settings.Login = {
    # Short press does nothing
    HandlePowerKey = "ignore";
    # Long press powers off
    HandlePowerKeyLongPress = "poweroff";
  };
}
