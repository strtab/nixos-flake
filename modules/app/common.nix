{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
{
  options.modules.common = {
    enable = lib.mkEnableOption "Enable common GUI packages";
  };
  config = lib.mkIf config.modules.common.enable {
    environment.systemPackages = with pkgs; [
      kdePackages.dolphin-plugins # File manager plugins
      kdePackages.dolphin # File manager
      kdePackages.ark # For openning archives in dolphin

      qbittorrent # Torrent client
      zathura # Pdf viewer
      nomacs # Image viewer
      haruna # Video viewer

      anki # Flash cards
    ];
  };
}
