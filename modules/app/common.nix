{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  helium = inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default;
  cfg = config.modules.common;
in
{
  options.modules.common.enable = lib.mkEnableOption "Enable common WM/GUI packages";
  config = lib.mkIf (cfg.enable) {
    xdg = {
      icons.enable = true;
      icons.fallbackCursorThemes = lib.mkDefault [ "breeze_cursors" ];
      portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gnome
          xdg-desktop-portal-gtk
          xdg-desktop-portal-wlr
          kdePackages.xdg-desktop-portal-kde
        ];
        config = {
          common.default = [ "kde" ];
        };
      };
    };

    systemd.services.warm-dm = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Type = "simple";
      path = [ pkgs.vmtouch ];
      script = ''
        vmtouch -t /home/${config.var.username}/.config/quickshell/aether
        vmtouch -t /home/${config.var.username}/.local/state/quickshell
        vmtouch -t /home/${config.var.username}/.cache/quickshell
        vmtouch -t /home/${config.var.username}/.config/hypr
      '';
    };

    environment.sessionVariables = {
      XDG_DATA_DIRS = [
        "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
      ];
    };

    qt.enable = true;
    environment.systemPackages =
      with pkgs;
      [
        qbittorrent # Torrent client
        zathura # Pdf viewer
        nomacs # Image viewer
        haruna # Video viewer

        helium

        anki # Flash cards

        xdg-user-dirs
        xdg-utils
      ]
      ++ (
        with pkgs.kdePackages;
        let
          geist = breeze.overrideAttrs (old: {
            pname = "geist";
            version = "local";
            src = inputs.geist;
            postInstall = ''
              mkdir -p $qt5/${pkgs.libsForQt5.qtbase.qtPluginPrefix}/styles
              mv $out/${pkgs.kdePackages.qtbase.qtPluginPrefix}/styles/geist5.so $qt5/${pkgs.libsForQt5.qtbase.qtPluginPrefix}/styles
            '';
          });
        in
        [
          pkgs.gtk3
          pkgs.gtk4

          # Hack? To make everything run on Wayland
          qtwayland
          qtsvg # Needed to render SVG icons

          # Frameworks with globally loadable bits
          frameworkintegration # provides Qt plugin
          kcoreaddons # provides extra mime type info
          kfilemetadata # provides Qt plugins
          kguiaddons # provides geo URL handlers
          kiconthemes # provides Qt plugins
          kimageformats # provides Qt plugins
          qtimageformats # provides optional image formats such as .webp and .avif
          kio # provides helper service + a bunch of other stuff
          kio-admin # managing files as admin
          kio-extras # stuff for MTP, AFC, etc
          kio-fuse # fuse interface for KIO
          kpackage # provides kpackagetool tool
          kservice # provides kbuildsycoca6 tool
          kunifiedpush # provides a background service and a KCM
          kwallet # provides helper service
          kwallet-pam # provides helper service
          kwalletmanager # provides KCMs and stuff
          solid # provides solid-hardware6 tool
          phonon-vlc # provides Phonon plugin

          # Core Plasma parts
          kde-cli-tools
          kwrited # wall message proxy, not to be confused with kwrite
          kdegraphics-thumbnailers # pdf etc thumbnailer
          polkit-kde-agent-1 # polkit auth ui
          drkonqi # crash handler

          # Application integration
          libplasma # provides Kirigami platform theme
          plasma-integration # provides Qt platform theme
          kde-gtk-config # syncs KDE settings to GTK

          # Artwork + themes
          geist
          pkgs.hicolor-icon-theme # fallback icons
          qqc2-breeze-style
          qqc2-desktop-style

          # misc Plasma extras
          kdeplasma-addons

          # Plasma utilities
          libksysguard
          kcmutils

          (lib.getBin qttools) # Expose qdbus in PATH
          ark
          dolphin
          dolphin-plugins
          ffmpegthumbs
          krdp
          kconfig # required for xdg-terminal from xdg-utils
          qtbase # for qtpaths which is required for xdg-mime from xdg-utils

          pkgs.openobex
          pkgs.obexftp
          powerdevil
          print-manager
          colord-kde
          plasma-thunderbolt
          qrca
          qtsensors
          geist.qt5
          plasma-integration.qt5
          kwayland-integration
          (
            # Only symlink the KIO plugins, so we don't accidentally pull any services
            # like KCMs or kcookiejar
            let
              kioPluginPath = "${pkgs.libsForQt5.qtbase.qtPluginPrefix}/kf5/kio";
              inherit (pkgs.libsForQt5.__internalKF5) kio;
            in
            pkgs.runCommand "kio5-plugins-only" { } ''
              mkdir -p $out/${kioPluginPath}
              ln -s ${kio}/${kioPluginPath}/* $out/${kioPluginPath}
            ''
          )
          kio-extras-kf5
        ]
      );

    environment.sessionVariables = {
      XDG_CONFIG_DIRS = [ "$HOME/.config/kdedefaults" ];
      KPACKAGE_DEP_RESOLVERS_PATH = "${pkgs.kdePackages.frameworkintegration.out}/libexec/kf6/kpackagehandlers";
    };

    programs = {
      # Enable GTK applications to load SVG icons
      gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
      gnupg.agent.pinentryPackage = lib.mkDefault pkgs.pinentry-qt;
      ssh.askPassword = lib.mkDefault "${pkgs.kdePackages.ksshaskpass.out}/bin/ksshaskpass";
      xwayland.enable = true;
      kde-pim.enable = true;
      dconf.enable = true;
    };

    services = {
      pipewire.enable = lib.mkDefault true;
      libinput.enable = lib.mkDefault true;
      fwupd.enable = lib.mkDefault true;
      gvfs.enable = lib.mkDefault true; # trash:// suppport
      system-config-printer.enable = lib.mkIf config.services.printing.enable (lib.mkDefault true);
      udev.packages = [
        pkgs.libmtp.out
        pkgs.media-player-info
      ];
    };

    # Set up Dr. Konqi as crash handler
    systemd.packages = [ pkgs.kdePackages.drkonqi ];
    systemd.services."drkonqi-coredump-processor@".wantedBy = [ "systemd-coredump@.service" ];
  };
}
