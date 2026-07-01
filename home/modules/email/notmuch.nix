{ lib , config , pkgs , ... }:
{
  services.mbsync.postExec = ''
    ${pkgs.notmuch}/bin/notmuch new
  '';

  home = {
    packages = [ pkgs.notmuch ];
    sessionVariables.NOTMUCH_CONFIG = lib.mkForce "${config.xdg.configHome}/notmuch.conf";
    file."${config.xdg.configHome}/notmuch.conf".enable = false;
    activation.linkNotmuchConfig = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      ln -sf "${config.age.secrets.notmuch.path}" "${config.xdg.configHome}/notmuch.conf"
      chmod 600 "${config.xdg.configHome}/notmuch.conf" 2>/dev/null || true
    '';
  };
}
