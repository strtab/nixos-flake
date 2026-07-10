{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      googlesans-code
      noto-fonts

      roboto-serif
      roboto-mono
      roboto-slab
      roboto-flex
      roboto
    ];

    fontDir.enable = true;

    fontconfig = {
      enable = true;
      antialias = true;
      defaultFonts = {
        monospace = ["JetBrainsMono Nerd Font" "Roboto Mono"];
        sansSerif = ["Google Sans Flex" "Noto Sans"];
        serif = ["Tex Gyre Schola" "Roboto Serif" "Noto Serif"];
      };
    };
  };
}
