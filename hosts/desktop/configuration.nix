{ config, pkgs, ... }:
{
  programs = {
    steam.enable = true;
  };

  services.udev = {
    packages = with pkgs; [
      qmk
      qmk-udev-rules # the only relevant
      qmk_hid
      via
      vial
    ];
  };

  environment.systemPackages = with pkgs; [
    kubectl
    stow
    tmux
  ];

  zramSwap.enable = false;
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 20 * 1024;
    }
  ];

  time.timeZone = "Europe/Moscow";

  imports = [
    # Init
    ./hardware-configuration.nix
    ./hardware # Hardware imports there
    ./variables.nix # Common variables
    ./network # Network configuration
    ./boot # Bootloader

    # System
    ./../../mods/system/nix.nix
    ./../../mods/system/users.nix
    ./../../mods/system/hyprland.nix
    ./../../mods/system/home-manager.nix
    ./../../mods/system/fonts.nix
    ./../../mods/system/pkgs.nix
    ./../../mods/system/utils.nix
    ./../../mods/system/tty.nix

    # Services
    ./../../mods/services/naiveproxy.nix
  ];

  home-manager.users."${config.var.username}" = import ./home.nix;
  system.stateVersion = "25.11";
}
