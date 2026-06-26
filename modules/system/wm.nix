{ config, ... }:
{
  services = {
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
}
