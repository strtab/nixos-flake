{ pkgs, ... }:
{
  systemd.services."log-cleaning" = {
    script = ''
      ${pkgs.coreutils}/bin/find /var/log -type f -mtime +10 -exec rm -f {} \;
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
    startAt = "hourly";
  };
}
