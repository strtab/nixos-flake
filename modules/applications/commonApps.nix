{ pkgs
, lib
, config
, ...
}:
{
  options = {
    commonApps = {
      enable = lib.mkEnableOption "Enable media applications";
    };
  };
  config = lib.mkIf config.commonApps.enable {
    environment.systemPackages = with pkgs; [
      kdePackages.dolphin-plugins # File manager plugins
      kdePackages.dolphin # File manager
      kdePackages.ark # For openning archives in dolphin

      qbittorrent # Torrent client
      zathura # Pdf viewer
      nomacs # Image viewer
      haruna # Video viewer

      google-chrome # Browser

      onlyoffice-desktopeditors # Office package

      kubectl
      tmux
      neomutt
      anki
    ];
  };
}
