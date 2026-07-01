{ pkgs
, inputs
, ...
}:
# TODO: update to theme https://github.com/vinceliuice/MacTahoe-icon-theme
# let
#   macOS-Tahoe-Cursor = pkgs.stdenv.mkDerivation {
#     pname = "MacTahoe-icon-theme";
#     version = "1.2";
#
#     src = pkgs.fetchzip {
#       url = "https://github.com/witt-bit/MacOS-Tahoe-Cursor/releases/download/${macOS-Tahoe-Cursor.version}/MacOS-Tahoe-Cursor.zip";
#       hash = "sha256-yr5GXQrtDl7aGFp84tpd6+IjgM9QVAlBMs9sAtrUPZc=";
#     };
#
#     dontCheckForBrokenSymlinks = true;
#
#     installPhase = ''
#       install -dm 0755 $out/share/icons
#       cp -r ./MacOS-Tahoe-Cursor $out/share/icons/
#     '';
#
#     dontDropIconThemeCache = true;
#     dontBuild = true;
#     dontConfigure = true;
#
#     meta = {
#       description = "Apple MacOS Tahoe Cursor for Linux and all Windows OS.";
#       homepage = "https://store.kde.org/p/2300466";
#       license = lib.licenses.asl20;
#       platforms = lib.platforms.linux;
#     };
#   };
# in
{
  imports = [ inputs.illogical-flake.homeManagerModules.default ];

  wayland.windowManager.hyprland.plugins = [
    inputs.hypr-dynamic-cursors.packages.${pkgs.stdenv.hostPlatform.system}.hypr-dynamic-cursors
  ];

  programs.illogical-impulse = {
    enable = true;
    hyprland = {
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
  };
}
