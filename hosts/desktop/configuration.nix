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
        version = "master-${inputs.llama-cpp.shortRev}";
        src = inputs.llama-cpp;
        buildInputs = (old.buildInputs or [ ]) ++ [
          pkgs-unstable.cudaPackages_12.cuda_nvml_dev
        ];
        doCheck = false;
        nativeBuildInputs = builtins.filter (p: (p.name or "") != "npm-config-hook") old.nativeBuildInputs;
        npmDeps = null;
        preConfigure = ''
          prependToVar cmakeFlags "-DLLAMA_BUILD_COMMIT:STRING=$(cat COMMIT)"
        '';
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
      ui = false;
      models = {
        "HauhauCS/Qwen3.6-35B-A3B-Uncensored-HauhauCS-Aggressive:Q4_K_P" = {
          hf = "HauhauCS/Qwen3.6-35B-A3B-Uncensored-HauhauCS-Aggressive";
          file = "Qwen3.6-35B-A3B-Uncensored-HauhauCS-Aggressive-Q4_K_P.gguf";
          mmproj = "mmproj-Qwen3.6-35B-A3B-Uncensored-HauhauCS-Aggressive-f16.gguf";
          settings = {
            load-mode = "none";
            no-mmproj-offload = true;
            n-gpu-layers = 99;
            ctx-size = 262000;
            cpu-mask = "0xFE";
            cpu-strict = 1;
            n-cpu-moe = 37;
            ctk = "q8_0";
            ctv = "q8_0";
            fa = "on";
            ub = 1024;
            b = 2048;
            np = 1;
            t = 7;
          };
        };
        "embedding" = {
          hf = "Qwen/Qwen3-Embedding-0.6B-GGUF:Q8_0";
          settings = {
            embedding = true;
            pooling = "last";
            sleep-idle-seconds = 30;
            ubatch-size = 8192;
            n-gpu-layers = 100;
          };
        };
      };
    };
  };

  home-manager.users."${config.var.username}" = import ./home.nix;
  system.stateVersion = "25.11";
}
