{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default # Zen browser
    onlyoffice-desktopeditors # Office package
    qbittorrent # Torrent client
    thunderbird # Mail client
    zathura # Pdf viewer
    nomacs # Image viewer
    haruna # Video viewer
    kitty # Terminal
    nwjs

    kdePackages.dolphin-plugins
    kdePackages.dolphin # File manager
    kdePackages.ark # Work with file archivers
  ];

  xdg.menus.enable = true;
}
