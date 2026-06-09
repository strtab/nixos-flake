{
  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [
    "modesetting"
  ];

  hardware = {
    # Enable OpenGL
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
