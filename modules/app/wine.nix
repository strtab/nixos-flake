{
  pkgs-unstable,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.wine;
in
{
  options.modules.wine.enable = lib.mkEnableOption "Whether enable wine";
  config = lib.mkIf cfg.enable {
    environment = {
      sessionVariables = {
        WINEPREFIX = "/var/lib/wine";
        WINEARCH = "win64";
      };
      systemPackages = with pkgs-unstable; [
        winetricks
        wineWow64Packages.stable
        wineWow64Packages.waylandFull
      ];
    };
  };
}
