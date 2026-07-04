# For syncing email to a local maildir
# https://gitlab.com/shackra/goimapnotify
{ lib , pkgs , config , ... }:
{
  home.packages = with pkgs; [
    goimapnotify
  ];
  systemd.user.services.goimapnotify = {
    Unit.Description = "IMAP IDLE notifier";
    Install.WantedBy = [ "default.target" ];
    Service = {
      ExecStart = "${pkgs.goimapnotify}/bin/goimapnotify -conf ${config.xdg.configHome}/goimapnotify/goimapnotify.yaml";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
  home.file."${config.xdg.configHome}/goimapnotify/goimapnotify.yaml".enable = lib.mkForce false;
  home.activation.linkGoimapnotifyConfig = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "${config.xdg.configHome}/goimapnotify"
    ln -sf "${config.age.secrets.goimapnotify.path}" "${config.xdg.configHome}/goimapnotify/goimapnotify.yaml"
    chmod 600 "${config.xdg.configHome}/isyncrc" 2>/dev/null || true
  '';
}
