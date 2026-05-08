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
    kdePackages.kdegraphics-thumbnailers
    kdePackages.qtsvg
  ];

  xdg.menus.enable = true;

  services.desktopManager.plasma6.enable = false;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    kate
    okular
    gwenview
    ktexteditor
    konsole
    spectacle
    discover
    plasma-browser-integration
    plasma-workspace-wallpapers
    kinfocenter
    plasma-systemmonitor
    drkonqi
    kglobalacceld
    kdegraphics-thumbnailers
    kde-inotify-survey
    kscreenlocker
  ];
}
