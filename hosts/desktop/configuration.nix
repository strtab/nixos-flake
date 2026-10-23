{ config, inputs, pkgs-master, ... }:
{
  imports = [
    (inputs.import-tree "${inputs.self}/modules")
    (inputs.import-tree ./hardware)
    ./variables.nix
  ];

  environment.sessionVariables = {
    no_proxy = "www.gravatar.com,.ptr.network,192.168.1.1,localhost,127.0.0.1,localaddress,.localdomain.com,bybit.com,stationx.mo,drweb.com,lo,anilib.me,kodikplayer.com,homelab,anilib.me,.ru,video1.cdnlibs.org,translate.yandex.com,vk.com,userapi.com,aeza.ru,.lan,nixos.wiki";
  };

  modules = {
    virt-manager.enable = true;
    # packettracer.enable = true;
    common.enable = true;
    office.enable = true;
    games.enable = true;
    wine.enable = true;
    vial.enable = true;
    hysteria = {
      useSecrets = true;
      enable = true;
    };
    ollama = {
      waitForNvidiaGpu = true;
      package = pkgs-master.ollama-cuda.override {
        cudaPackages = pkgs-master.cudaPackages_12;
        cudaArches = [ "61" ];
      };
      enable = true;
    };
  };

  home-manager.users."${config.var.username}" = import ./home.nix;
  system.stateVersion = "25.11";
}
