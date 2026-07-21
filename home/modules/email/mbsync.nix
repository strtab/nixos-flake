# For syncing email to a local maildir
# https://isync.sourceforge.io/mbsync.html
{
  lib,
  pkgs,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    isync
  ];
  # programs.mbsync = {
  #   enable = true;
  #   package = pkgs.isync;
  # };
  # services.mbsync = {
  #   enable = true;
  #   package = pkgs.isync;
  #   configFile = "${config.xdg.configHome}/isyncrc";
  #   preExec = ''
  #     ${pkgs.coreutils}/bin/mkdir -p ${config.home.homeDirectory}/.local/mail
  #   '';
  # };
  home.file."${config.xdg.configHome}/isyncrc".enable = lib.mkForce false;
  home.activation.linkMbsyncConfig = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    ln -sf "${config.age.secrets.isyncrc.path}" "${config.xdg.configHome}/isyncrc"
    chmod 600 "${config.xdg.configHome}/isyncrc" 2>/dev/null || true
  '';
}
