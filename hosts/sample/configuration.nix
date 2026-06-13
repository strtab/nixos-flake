{ config, ... }:
{
  zramSwap.enable = false;
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 2 * 1024;
    }
  ];

  time.timeZone = "Europe/Moscow";

  imports = [
    # Init
    /etc/nixos/hardware-configuration.nix
    ./hardware # Hardware imports there
    ./variables.nix # Common variables
    ./network # Network configuration
    ./boot # Bootloader

    # System
    ./../../mods/system/nix.nix
    ./../../mods/system/users.nix
    ./../../mods/system/hyprland.nix
    ./../../mods/system/home-manager.nix
    ./../../mods/system/window-manager.nix
    ./../../mods/system/fonts.nix
    ./../../mods/system/pkgs.nix
    ./../../mods/system/utils.nix
    ./../../mods/system/tty.nix
  ];

  home-manager.users."${config.var.username}" = import ./home.nix;
  system.stateVersion = "25.11";
}
