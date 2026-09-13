{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      inter
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
