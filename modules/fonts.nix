{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      inter

      vista-fonts
      corefonts

      twemoji-color-font

      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts

      nerd-fonts.jetbrains-mono
      geist-font
    ];

    fontDir.enable = true;

    fontconfig = {
      enable = true;
      antialias = true;
      hinting = {
        enable = true;
        style = "slight";
      };
      subpixel.rgba = "none";
      defaultFonts = {
        monospace = [
          "Geist Mono Medium"
          "JetBrainsMono Nerd Font"
          "Roboto Mono"
        ];
        emoji = [ "Twitter Color Emoji" ];
        sansSerif = [
          "Inter"
          "Noto Sans"
        ];
        serif = [
          "Tex Gyre Schola"
          "Noto Serif"
        ];
      };
    };
  };
}
