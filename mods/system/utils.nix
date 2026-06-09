{ pkgs, ... }:
{
  programs = {
    nano.enable = false;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    dconf.enable = true;
    # appimage = {
    #   enable = true;
    #   binfmt = true;
    #   package = pkgs.appimage-run.override {
    #     extraPkgs = pkgs: [
    #       pkgs.qt6.qtwayland
    #       pkgs.libxkbcommon
    #     ];
    #   };
    # };

    mtr.enable = true;
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
    sudo.wheelNeedsPassword = false;
  };

  documentation = {
    enable = true;
    man.enable = true;
    man.cache.enable = true;

    doc.enable = false;
    dev.enable = false;
    info.enable = false;
    nixos.enable = false;
  };

  # enable zsh autocompletion for system packages (systemd, etc)
  environment.pathsToLink = [ "/share/zsh" ];

  environment.systemPackages = with pkgs; [
    uutils-coreutils-noprefix # coreutils
    usbutils
    ripgrep
    hwinfo
    pstree
    ffmpeg
    ntfs3g
    neovim
    tree
    lsof
    git
    xxd
    fd
    jq

    # Arcivers
    p7zip
    unrar
    unzip
    unar
    gzip
    zip

    # Development
    pkg-config
    luarocks
    python3
    gnumake
    nodejs
    rustc
    cargo
    cmake
    lua
    gcc
    go
  ];

  xdg = {
    portal.enable = true;
    portal.extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
      kdePackages.xdg-desktop-portal-kde
    ];
  };

  environment.sessionVariables = {
    XDG_DATA_DIRS = [
      "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
    ];
  };

  services = {
    geoclue2.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
    desktopManager.plasma6.enable = false;
  };

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

  programs = {
    nix-ld = {
      # Dynamic liblaries
      enable = true;
      libraries = with pkgs; [
        zlib
        zstd
        stdenv.cc.cc
        curl
        openssl
        attr
        libssh
        bzip2
        libxml2
        acl
        libsodium
        util-linux
        xz
        systemd

        pango
        cairo
        atk
        gdk-pixbuf
        fontconfig
        freetype
        dbus
        alsa-lib
        expat
        libxkbcommon
        fribidi
        harfbuzz
        libgpg-error
        gmp

        brotli
        unixodbc

        libxcomposite
        libxtst
        libxrandr
        libxext
        libx11
        libxfixes
        libGL
        libva
        pipewire
        libxcb
        libxdamage
        libxshmfence
        libxxf86vm
        libelf

        # Required
        glib
        gtk2

        # Inspired by steam
        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/st/steam/package.nix#L36-L85
        networkmanager
        vulkan-loader
        libgbm
        libdrm
        libxcrypt
        coreutils
        pciutils
        zenity
        # glibc_multi.bin # Seems to cause issue in ARM

        # # Without these it silently fails
        libxinerama
        libxcursor
        libxrender
        libxscrnsaver
        libxi
        libsm
        libice
        gnome2.GConf
        nspr
        nss
        cups
        libcap
        SDL2
        libusb1
        dbus-glib
        ffmpeg
        libudev0-shim

        # Verified games requirements
        libxt
        libxmu
        libogg
        libvorbis
        SDL
        SDL2_image
        glew_1_10
        libidn
        tbb

        # Other things from runtime
        flac
        freeglut
        libjpeg
        libpng
        libpng12
        libsamplerate
        libmikmod
        libtheora
        libtiff
        pixman
        speex
        SDL_image
        SDL_ttf
        SDL_mixer
        SDL2_ttf
        SDL2_mixer
        libappindicator-gtk2
        libdbusmenu-gtk2
        libindicator-gtk2
        libcaca
        libcanberra
        libgcrypt
        libvpx
        librsvg
        libxft
        libvdpau

        libxcrypt-legacy # For natron
        libGLU # For natron

        # Appimages need fuse, e.g. https://musescore.org/fr/download/musescore-x86_64.AppImage
        fuse
        e2fsprogs
      ];
    };
  };
}
