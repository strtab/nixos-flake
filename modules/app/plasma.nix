{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.modules.plasma;
in
{
  options.modules.plasma = {
    enable = lib.mkEnableOption "Enable plasma";
  };
  config = lib.mkIf cfg.enable {
    qt.enable = true;
    programs.xwayland.enable = true;
    environment.systemPackages =
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

        requiredPackages = [
          qtwayland # Hack? To make everything run on Wayland
          qtsvg # Needed to render SVG icons

          # Frameworks with globally loadable bits
          frameworkintegration # provides Qt plugin
          kauth # provides helper service
          kcoreaddons # provides extra mime type info
          kded # provides helper service
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
          baloo # system indexer
          milou # search engine atop baloo
          kdegraphics-thumbnailers # pdf etc thumbnailer
          polkit-kde-agent-1 # polkit auth ui
          drkonqi # crash handler

          # Application integration
          libplasma # provides Kirigami platform theme
          plasma-integration # provides Qt platform theme
          kde-gtk-config # syncs KDE settings to GTK

          # Artwork + themes
          geist
          breeze-icons
          breeze-gtk
          ocean-sound-theme
          pkgs.hicolor-icon-theme # fallback icons
          qqc2-breeze-style
          qqc2-desktop-style

          # misc Plasma extras
          kdeplasma-addons
          pkgs.xdg-user-dirs # recommended upstream

          # Plasma utilities
          libksysguard
          kcmutils

          (lib.getBin qttools) # Expose qdbus in PATH
          ark
          khelpcenter
          dolphin
          dolphin-plugins
          ffmpegthumbs
          krdp
          kconfig # required for xdg-terminal from xdg-utils
          qtbase # for qtpaths which is required for xdg-mime from xdg-utils
          qtvirtualkeyboard # used by plasma-keyboard KCM

          pkgs.openobex
          pkgs.obexftp
          powerdevil
          print-manager
          colord-kde
          plasma-thunderbolt
          kdenetwork-filesharing
          qrca
        ]
        ++ lib.optionals config.hardware.sensor.iio.enable [
          # This is required for autorotation in Plasma 6
          qtsensors
        ];
      in
      requiredPackages
      ++ lib.optionals config.services.desktopManager.plasma6.enableQt5Integration [
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
      ];

    # Add ~/.config/kdedefaults to XDG_CONFIG_DIRS for shells, since Plasma sets that.
    # FIXME: maybe we should append to XDG_CONFIG_DIRS in /etc/set-environment instead?
    environment.sessionVariables.XDG_CONFIG_DIRS = [ "$HOME/.config/kdedefaults" ];

    # Needed for things that depend on other store.kde.org packages to install correctly,
    # notably Plasma look-and-feel packages (a.k.a. Global Themes)
    #
    # FIXME: this is annoyingly impure and should really be fixed at source level somehow,
    # but kpackage is a library so we can't just wrap the one thing invoking it and be done.
    # This also means things won't work for people not on Plasma, but at least this way it
    # works for SOME people.
    environment.sessionVariables.KPACKAGE_DEP_RESOLVERS_PATH = "${pkgs.kdePackages.frameworkintegration.out}/libexec/kf6/kpackagehandlers";

    # Enable GTK applications to load SVG icons
    programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];

    programs.gnupg.agent.pinentryPackage = lib.mkDefault pkgs.pinentry-qt;
    programs.kde-pim.enable = lib.mkDefault true;
    programs.ssh.askPassword = lib.mkDefault "${pkgs.kdePackages.ksshaskpass.out}/bin/ksshaskpass";

    # Enable helpful DBus services.
    services.accounts-daemon.enable = true;
    # when changing an account picture the accounts-daemon reads a temporary file containing the image which systemsettings5 may place under /tmp
    systemd.services.accounts-daemon.serviceConfig.PrivateTmp = false;

    services.power-profiles-daemon.enable = lib.mkDefault true;
    services.system-config-printer.enable = lib.mkIf config.services.printing.enable (
      lib.mkDefault true
    );
    services.udisks2.enable = true;
    services.upower.enable = config.powerManagement.enable;
    services.libinput.enable = lib.mkDefault true;
    services.geoclue2.enable = lib.mkDefault true;
    services.fwupd.enable = lib.mkDefault true;

    # Extra UDEV rules used by Solid
    services.udev.packages = [
      # libmtp has "bin", "dev", "out" outputs. UDEV rules file is in "out".
      pkgs.libmtp.out
      pkgs.media-player-info
    ];

    # Set up Dr. Konqi as crash handler
    systemd.packages = [ pkgs.kdePackages.drkonqi ];
    systemd.services."drkonqi-coredump-processor@".wantedBy = [ "systemd-coredump@.service" ];

    xdg.icons.enable = true;
    xdg.icons.fallbackCursorThemes = lib.mkDefault [ "breeze_cursors" ];

    xdg.portal.enable = true;
    xdg.portal.extraPortals = [
      pkgs.kdePackages.kwallet
      pkgs.kdePackages.xdg-desktop-portal-kde
      pkgs.xdg-desktop-portal-gtk
    ];
    services.pipewire.enable = lib.mkDefault true;

    # Enable screen reader by default
    services.orca.enable = lib.mkDefault true;

    security.pam.services = {
      login.kwallet = {
        enable = true;
        package = pkgs.kdePackages.kwallet-pam;
      };
      kde = {
        allowNullPassword = true;
        kwallet = {
          enable = true;
          package = pkgs.kdePackages.kwallet-pam;
        };
        # "kde" must not have fingerprint authentication otherwise it can block password login.
        # See https://github.com/NixOS/nixpkgs/issues/239770 and https://invent.kde.org/plasma/kscreenlocker/-/merge_requests/163.
        fprintAuth = false;
        p11Auth = false;
      };
      kde-fingerprint = lib.mkIf config.services.fprintd.enable {
        fprintAuth = true;
        p11Auth = false;
      };
      kde-smartcard = lib.mkIf config.security.pam.p11.enable {
        p11Auth = true;
        fprintAuth = false;
      };
    };

    security.wrappers = {
      ksystemstats_intel_helper = {
        owner = "root";
        group = "root";
        capabilities = "cap_perfmon+ep";
        source = "${pkgs.kdePackages.ksystemstats}/libexec/ksystemstats_intel_helper";
      };

      ksgrd_network_helper = {
        owner = "root";
        group = "root";
        capabilities = "cap_net_raw+ep";
        source = "${pkgs.kdePackages.libksysguard}/libexec/ksysguard/ksgrd_network_helper";
      };
    };

    # Upstream recommends allowing set-timezone and set-ntp so that the KCM and
    # the automatic timezone logic work without user interruption.
    # However, on NixOS NTP cannot be overwritten via dbus, and timezone
    # can only be set if `time.timeZone` is set to `null`. So, we only allow
    # set-timezone, and we only allow it when the timezone can actually be set.
    security.polkit.extraConfig = lib.mkIf (config.time.timeZone != null) ''
      polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.timedate1.set-timezone" && subject.active) {
          return polkit.Result.YES;
        }
      });
    '';

    programs.dconf.enable = true;

    programs.kdeconnect.package = pkgs.kdePackages.kdeconnect-kde;
    programs.partition-manager.package = pkgs.kdePackages.partitionmanager;
  };
}
