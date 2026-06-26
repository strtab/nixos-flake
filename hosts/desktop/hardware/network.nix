{
  config,
  pkgs,
  lib,
  ...
}:
{
  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp14s0.useDHCP = lib.mkDefault true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = false;

  networking = {
    hostName = config.var.hostname;

    hosts = {
      "127.0.0.1" = [
        "lo"
        "localhost"
      ];
    };

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    firewall.enable = false;

    networkmanager.enable = true; # Easiest to use and most distros use this by default.
    networkmanager.plugins = with pkgs; [ networkmanager-openvpn ];
  };

  environment.systemPackages = with pkgs; [
    openvpn
    openssh

    samba
    freerdp

    inetutils
    w3m-full
    curlFull
    rsync
    wget
    nmap
    dig
  ];
}
