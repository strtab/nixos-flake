{ pkgs
, lib
, config
, ...
}:
{
  options.modules.plasma = {
    enable = lib.mkEnableOption "Enable plasma";
  };
  config = lib.mkIf config.modules.plasma.enable {
    services.desktopManager.plasma6.enable = true;
    # TODO: review this list and remove packages that are not needed
    # TODO: remove emojier from packages
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      elisa
      kate
      okular
      gwenview
      ktexteditor
      konsole
      spectacle
      discover
      plasma-settings
      plasma-browser-integration
      plasma-workspace-wallpapers
      kinfocenter
      plasma-systemmonitor
      drkonqi
      kglobalacceld
      kdegraphics-thumbnailers
      kde-inotify-survey
      kscreenlocker
      kwin
    ];
  };
}
