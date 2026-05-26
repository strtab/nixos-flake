{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    googlesans-code
    noto-fonts
  ];
}
