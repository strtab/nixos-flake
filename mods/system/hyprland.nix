{
  config,
  pkgs,
  lib,
  ...
}:
let
  macOS-Tahoe-Cursor = pkgs.stdenv.mkDerivation {
    pname = "MacTahoe-icon-theme";
    version = "1.2";

    src = pkgs.fetchzip {
      url = "https://github.com/witt-bit/MacOS-Tahoe-Cursor/releases/download/${macOS-Tahoe-Cursor.version}/MacOS-Tahoe-Cursor.zip";
      hash = "sha256-yr5GXQrtDl7aGFp84tpd6+IjgM9QVAlBMs9sAtrUPZc=";
    };

    dontCheckForBrokenSymlinks = true;

    installPhase = ''
      install -dm 0755 $out/share/icons
      cp -r ./MacOS-Tahoe-Cursor $out/share/icons/
    '';

    dontDropIconThemeCache = true;
    dontBuild = true;
    dontConfigure = true;

    meta = {
      description = "Apple MacOS Tahoe Cursor for Linux and all Windows OS.";
      homepage = "https://store.kde.org/p/2300466";
      license = lib.licenses.asl20;
      platforms = lib.platforms.linux;
    };
  };
in
{
  xdg = {
    icons.fallbackCursorThemes = [ "MacOS-Tahoe-Cursor" ];
    portal.enable = true;
    portal.extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
      kdePackages.xdg-desktop-portal-kde
    ];
  };

  environment.systemPackages = [ macOS-Tahoe-Cursor ];

  environment.sessionVariables = {
    XDG_DATA_DIRS = [
      "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
    ];
  };

  services = {
    geoclue2.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;

    greetd = {
      enable = true;
      settings = {
        initial_session = {
          command = "start-hyprland";
          user = config.var.username;
        };
        default_session = {
          command = "start-hyprland";
          user = config.var.username;
        };
      };
    };
  };

  programs.dconf.enable = true;
}
