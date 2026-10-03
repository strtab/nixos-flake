# For syncing email to a local maildir
# https://isync.sourceforge.io/mbsync.html
{
  lib,
  pkgs,
  config,
  ...
}:
{
  home.packages = with pkgs; [ isync ];
  home.file."${config.xdg.configHome}/isyncrc".enable = lib.mkForce false;
  home.activation.linkIsyncConfig = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    ln -sf "${config.age.secrets.isyncrc.path}" "${config.xdg.configHome}/isyncrc"
    chmod 600 "${config.xdg.configHome}/isyncrc" 2>/dev/null || true
  '';
  home.activation.initIsync =
    config.lib.dag.entryAfter
      [
        "linkIsyncConfig"
        "linkGoimapnotifyConfig"
      ]
      ''
        ${pkgs.isync}/bin/mbsync -qls 2>&1 | ${pkgs.gawk}/bin/awk -v q="'" '
          /^Maildir error: cannot open store/ {
            path = $NF
            gsub(q, "", path)
            system("mkdir -p \"" path "\"")
          }
        ' || true
        ${pkgs.isync}/bin/mbsync -a || true
      '';
}
