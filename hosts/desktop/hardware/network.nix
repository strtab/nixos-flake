{ config, pkgs, ... }:
{
  services = { openssh.enable = true; };
  networking = {
    hostName = config.var.hostname;

    hosts = {
      "127.0.0.1" = [
        "lo"
        "localhost"
      ];
    };

    networkmanager = {
      enable = true;
      plugins = with pkgs; [ networkmanager-openvpn ];
    };
  };
}
