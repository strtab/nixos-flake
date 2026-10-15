{ config, ... }:
{
  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  boot.kernelModules = [ "nvidia_uvm" ];

  hardware = {
    # Enable OpenGL
    nvidia = {
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
      modesetting = {
        enable = true;
      };
    };
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
