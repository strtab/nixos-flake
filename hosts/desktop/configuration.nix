{
  config,
  inputs,
  pkgs-unstable,
  ...
}:
let
  llama-cpp-pascal =
    (pkgs-unstable.llama-cpp.override {
      cudaSupport = true;
      # CUDA 13 dropped Pascal (sm_61), so pin the CUDA 12 toolchain
      cudaPackages = pkgs-unstable.cudaPackages_12;
    }).overrideAttrs
      (old: {
        # Build kernels for GTX 1080 only (compute capability 6.1); the last flag wins
        cmakeFlags = (old.cmakeFlags or [ ]) ++ [ "-DCMAKE_CUDA_ARCHITECTURES=61" ];
      });
in
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
    borgbackup.enable = true;
    hysteria = {
      useSecrets = true;
      enable = true;
    };
    llama-cpp = {
      enable = true;
      package = llama-cpp-pascal;
      models = {
        "HauhauCS/Qwen3.6-35B-A3B-Uncensored-HauhauCS-Aggressive:Q4_K_P" = {
          hf = "HauhauCS/Qwen3.6-35B-A3B-Uncensored-HauhauCS-Aggressive";
          file = "Qwen3.6-35B-A3B-Uncensored-HauhauCS-Aggressive-Q4_K_P.gguf";
          mmproj = "mmproj-Qwen3.6-35B-A3B-Uncensored-HauhauCS-Aggressive-f16.gguf";
          settings = {
            n-cpu-moe = 40;
            n-gpu-layers = 95;
            ctx-size = "128000";
          };
        };
      };
    };
  };

  home-manager.users."${config.var.username}" = import ./home.nix;
  system.stateVersion = "25.11";
}
