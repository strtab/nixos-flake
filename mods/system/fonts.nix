{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    liberation_ttf_v2
    googlesans-code
    noto-fonts
  ];
}
