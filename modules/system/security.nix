{ config, pkgs, ... }:
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
    # If enabled, pam_wallet will attempt to automatically unlock the user’s default KDE wallet upon login.
    # If the user has no wallet named “kdewallet”, or the login password does not match their wallet password,
    # KDE will prompt separately after login.
    pam = {
      services = {
        ${config.var.username} = {
          kwallet = {
            enable = true;
            package = pkgs.kdePackages.kwallet-pam;
          };
        };
      };
    };
  };
}
