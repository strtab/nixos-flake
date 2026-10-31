{
  config,
  inputs,
  pkgs-master,
  ...
}:
{
  imports = [
    (inputs.import-tree "${inputs.self}/modules")
    (inputs.import-tree ./hardware)
    ./variables.nix
  ];

  environment.sessionVariables = {
    no_proxy = "kodikplayer.com,www.gravatar.com,.ptr.network,192.168.1.1,localhost,127.0.0.1,localaddress,.localdomain.com,bybit.com,stationx.mo,drweb.com,lo,anilib.me,kodikplayer.com,homelab,anilib.me,.ru,video1.cdnlibs.org,translate.yandex.com,vk.com,userapi.com,aeza.ru,.lan,nixos.wiki";
  };

  modules = {
    common.enable = true;
    office.enable = true;
    games.enable = true;
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
      customModels."qwen-coder-autocomplete" = {
        from = "qwen2.5-coder:7b-base";
        parameters = {
          temperature = 0.1;
          top_p = 0.9;
          num_ctx = 4096;
          num_predict = 128;
          stop = [
            "<|fim_prefix|>"
            "<|fim_suffix|>"
            "<|fim_middle|>"
            "<|file_sep|>"
            "<|endoftext|>"
          ];
        };
      };
      enable = true;
    };
  };

  home-manager.users."${config.var.username}" = import ./home.nix;
  system.stateVersion = "25.11";
}
