{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      googlesans-code
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts

      geist-font
    ];

    fontDir.enable = true;

    fontconfig = {
      enable = true;
      antialias = true;
      defaultFonts = {
        monospace = ["JetBrainsMono Nerd Font" "Roboto Mono"];
        sansSerif = ["Google Sans Flex" "Noto Sans"];
        serif = ["Tex Gyre Schola" "Noto Serif"];
      };
    };
  };
}
