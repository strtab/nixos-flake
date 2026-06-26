{ ... }:
{
  services = {
    gnome.gnome-keyring.enable = true;
  };

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    mtr.enable = true; # my traceroute package, needed for network cap (maby...)
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;

    sudo.enable = false; # We will use sudo-rs instead of the traditional sudo package
    sudo-rs = {
      enable = true;
      execWheelOnly = true;
      extraConfig = ''
        # Allow members of the wheel group to execute any command without a password
        %wheel ALL=(ALL) NOPASSWD: ALL
      '';
    };
  };
}
