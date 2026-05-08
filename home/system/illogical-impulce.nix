{ inputs, ... }:
# let
# iconsOverride = pkgs.stdenv.mkDerivation {
#   pname = "BigSur-icon-theme";
#   version = "1.0.0";
#   src = pkgs.fetchFromGitHub {
#     owner = "yeyushengfan258";
#     repo = "BigSur-icon-theme";
#     rev = "9eac0309f53d32d26aea1fff55f9a56ae97769f6";
#     hash = "sha256-E+dMvCTGBzpw74wcYu5XVabc+G3KDnd9KqM/uZ1jhL4=";
#   };
#   nativeBuildInputs = [ pkgs.bash ];
#   dontCheckForBrokenSymlinks = true;
#
#   postPatch = ''
#     patchShebangs install.sh
#     sed -i 's/gtk-update-icon-cache/true/' install.sh
#   '';
#
#   installPhase = ''
#     mkdir -p $out/share/icons
#     ./install.sh -t all -d $out/share/icons/
#   '';
#   meta = {
#     description = "A colorful Design icon theme for linux desktops ";
#     homepage = "https://github.com/yeyushengfan258/BigSur-icon-theme";
#   };
# };
# in
{
  imports = [ inputs.illogical-flake.homeManagerModules.default ];
  # home.packages = [ iconsOverride ];

  programs.illogical-impulse = {
    enable = true;
    # icons = {
    #   dark = "BigSur-icon-theme-1.0.0-dark";
    #   light = "BigSur-icon-theme-1.0.0-light";
    #   package = iconsOverride;
    # };
  };
}
