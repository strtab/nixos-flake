{ config, inputs, ... }:
{
  imports = [
    (inputs.import-tree "${inputs.self}/modules")
    (inputs.import-tree ./hardware)
    ./variables.nix
  ];

  environment.sessionVariables = {
    no_proxy = "192.168.1.1,localhost,127.0.0.1,localaddress,.localdomain.com,bybit.com,stationx.mo,drweb.com,lo,anilib.me,kodikplayer.com,homelab,anilib.me,.ru,video1.cdnlibs.org,translate.yandex.com,vk.com,userapi.com,aeza.ru,.lan,nixos.wiki";
  };

  modules = {
    common.enable = true;
    plasma.enable = true;
    games.enable = true;
    vial.enable = true;
    services = {
      hysteria = {
        useSecrets = true;
        enable = true;
      };
    };
  };

  home-manager.users."${config.var.username}" = import ./home.nix;
  system.stateVersion = "25.11";
}
