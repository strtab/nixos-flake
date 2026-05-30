{
  inputs,
  # pkgs,
  # lib,
  ...
}:
# let
#   mactahoe-icon-theme = pkgs.stdenv.mkDerivation {
#     pname = "MacTahoe-icon-theme";
#     version = "2025-10-16";
#
#     src = pkgs.fetchFromGitHub {
#       owner = "vinceliuice";
#       repo = "MacTahoe-icon-theme";
#       tag = "${mactahoe-icon-theme.version}";
#       hash = "sha256-2Tj4PmecvVA3T5GmKBkYdkjnspIue/u0LiYPaNMXk10=";
#     };
#
#     dontCheckForBrokenSymlinks = true;
#
#     nativeBuildInputs = [ pkgs.gtk3 ];
#
#     propagatedBuildInputs = [
#       pkgs.plasma5Packages.breeze-icons
#       pkgs.gnome-icon-theme
#       pkgs.hicolor-icon-theme
#     ];
#
#     installPhase = ''
#       runHook preInstall
#
#       mkdir -p $out/share/icons
#       patchShebangs install.sh
#       ./install.sh -t all -d $out/share/icons/
#
#       runHook postInstall
#     '';
#
#     dontDropIconThemeCache = true;
#     dontBuild = true;
#     dontConfigure = true;
#
#     meta = {
#       description = "MacOS Tahoe icon theme for linux ";
#       homepage = "https://github.com/vinceliuice/MacTahoe-icon-theme/tree/main";
#       license = lib.licenses.gpl3Only;
#       platforms = lib.platforms.linux;
#     };
#   };
# in
{
  imports = [ inputs.illogical-flake.homeManagerModules.default ];
  # home.packages = [ mactahoe-icon-theme ];

  programs.illogical-impulse = {
    enable = true;
    # icons = {
    #   dark = "MacTahoe-icon-theme-2025-10-16-dark";
    #   light = "MacTahoe-icon-theme-2025-10-16-light";
    #   package = mactahoe-icon-theme;
    # };
  };
}
