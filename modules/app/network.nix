{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    openvpn
    openssh

    samba
    freerdp

    inetutils
    dnsutils
    curlFull
    sshfs
    rsync
    wget
    nmap
    dig
  ];
}
