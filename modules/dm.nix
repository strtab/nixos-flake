{ config, pkgs, ... }:
let
  session = "${pkgs.systemd}/bin/systemd-cat -t hyprland start-hyprland";
in
{
  services.greetd = {
    enable = true;
    
    settings = {
      initial_session = {
        command = session;
        user = config.var.username;
      };
      default_session = {
        command = session;
        user = config.var.username;
      };
    };
  };
}
