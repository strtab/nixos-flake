{ config, ... }:
{
  time.timeZone = config.var.timezone;
  services = {
    geoclue2.enable = true;
  };
}
