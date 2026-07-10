{ pkgs , lib , config , ... }:
{
  options.modules.nix.ld.enable = lib.mkEnableOption "nix dynamic liblaries" // {
    default = true;
  };

  config = lib.mkIf config.modules.nix.ld.enable {
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

          # For tauri
          webkitgtk_4_1
          waylandpp
        ];
      };
    };
  };
}
