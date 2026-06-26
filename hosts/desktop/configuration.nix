{ config, inputs, ... }:
{
  imports = [ 
    (inputs.import-tree ../../modules)
    (inputs.import-tree ./hardware)
    ./variables.nix
  ];
  
  commonApps.enable = true;
  games.enable = true;
  
  plasma.enable = true;

  vial.enable = true;

  _services.naiveproxy.enable = true;

  zramSwap.enable = false;
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 20 * 1024;
    }
  ];

  time.timeZone = "Europe/Moscow";

  home-manager.users."${config.var.username}" = import ./home.nix;
  system.stateVersion = "25.11";
}
