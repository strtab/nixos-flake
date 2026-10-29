{ pkgs, ... }:
{
  systemd.services."log-cleaning" = {
    script = ''
      # Remove log files older than 10 days
      ${pkgs.findutils}/bin/find /var/log -type f -mtime +10 -delete

      # Remove empty directories (children first), keep /var/log itself and the journal
      ${pkgs.findutils}/bin/find /var/log -mindepth 1 -type d -empty \
        -not -path '/var/log/journal*' -delete
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
    startAt = "hourly";
  };
}
