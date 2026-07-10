{ pkgs, ... }:
{
  programs = {
    nano.enable = false;
    dconf.enable = true;

    appimage = {
      enable = true;
      binfmt = true;
      package = pkgs.appimage-run.override {
        extraPkgs = pkgs: [
          pkgs.qt6.qtwayland
          pkgs.libxkbcommon
        ];
      };
    };
  };

  documentation = {
    enable = true;
    man.enable = true;
    man.cache.enable = false; # enable if you want to use apropos(1)

    doc.enable = false;
    dev.enable = false;
    info.enable = false;
    nixos.enable = false;
  };

  # enable zsh autocompletion for system packages (systemd, etc)
  environment.pathsToLink = [ "/share/zsh" ];

  environment.systemPackages = with pkgs; [
    uutils-coreutils-noprefix
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

    # arcivers
    p7zip
    unrar
    unzip
    unar
    gzip
    zip

    # development
    wrapGAppsHook4
    pkg-config
    luarocks
    python3
    gnumake
    nodejs
    rustc
    cargo-tauri
    cargo
    cmake
    lua
    gcc
    go
  ];
}
