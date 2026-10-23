{ pkgs-unstable, ... }:
{
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
}
