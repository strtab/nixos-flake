{
  config,
  inputs,
  pkgs-unstable,
  lib,
  ...
}:
let
  noProxy = lib.concatStringsSep "," [
    "localhost"
    "127.0.0.1"
    "192.168.1.1"
    "homelab"
    ".lan"
    ".localdomain.com"
    ".ptr.network"
    ".ru"
    "anilib.me"
    "kodikplayer.com"
    "video1.cdnlibs.org"
    "www.gravatar.com"
    "bybit.com"
    "stationx.mo"
    "drweb.com"
    "translate.yandex.com"
    "vk.com"
    "userapi.com"
    "nixos.wiki"
  ];
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
    no_proxy = noProxy;
    NO_PROXY = noProxy;
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
            no-mmproj = true;
            n-gpu-layers = 99;
            ctx-size = 262000;
            cpu-mask = "0xFE";
            cpu-strict = 1;
            n-cpu-moe = 38;
            ctk = "q8_0";
            ctv = "q8_0";
            fa = "on";
            ub = 1024;
            b = 2048;
            np = 1;
            t = 7;
          };
        };
      };
    };
  };

  home-manager.users."${config.var.username}" = import ./home.nix;
  system.stateVersion = "25.11";
}
