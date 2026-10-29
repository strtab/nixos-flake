{ config, ... }:
{
  home.activation.cleanKServiceCache = config.lib.dag.entryAfter [ "setXdgRuntimeDir" ] ''
    rm -rf ${config.home.homeDirectory}/.cache/ksycoca6_* || true
  '';
}
