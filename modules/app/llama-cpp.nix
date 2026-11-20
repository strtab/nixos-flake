# ---------------------------------------------------------------
# Usage
# ---------------------------------------------------------------
#
# modules.llama-cpp = {
#   enable = true;
#   package = llama-cpp-pascal;
#   keepAlive = null; # Keep models loaded
#   modelsMax = 2; # chat model and embedding model resident together
#   ui = false; # disable the built-in web UI of the main server
#
#   models."qwen-agent" = {
#     hf = "fredrezones55/Qwen3.6-35B-A3B-Uncensored-HauhauCS-Aggressive:Q4_K_P";
#     settings.temp = 0.6; # optional llama-server flags without dashes
#     settings.n-cpu-moe = 40;
#   };
#   models."coder" = {
#     hf = "Qwen/Qwen2.5-Coder-7B-GGUF";
#     file = "qwen2.5-coder-7b-q8_0.gguf"; # exact file instead of a quant tag
#   };
#
#   # Embedding model for RAG tools (pi-semsearch, pi-knowledge): loaded on
#   # demand and unloaded after sleep-idle-seconds.
#   # Clients use port 9931 and the model name "embedding".
#   models."embedding" = {
#     hf = "Qwen/Qwen3-Embedding-0.6B-GGUF:Q8_0";
#     settings = {
#       embedding = true;
#       pooling = "last";
#       ubatch-size = 8192;
#       sleep-idle-seconds = 30;
#       n-gpu-layers = 100; # 0 keeps it off the GPU
#     };
#   };
# };
#
# Models are downloaded from Hugging Face on first request into
# /var/cache/llama-cpp and selected by name in the API "model" field.

{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.modules.llama-cpp;

  # defaults for every model (override via `settings`)
  defaults = {
    flash-attn = "on";
    load-mode = "none";
  };

  renderValue = v: if builtins.isBool v then (if v then "on" else "off") else toString v;

  modelPreset =
    name: m:
    {
      hf-repo = m.hf;
    }
    // lib.optionalAttrs (m.file != null) { hf-file = m.file; }
    // lib.optionalAttrs (m.mmproj != null) {
      mmproj-url = "https://huggingface.co/${lib.head (lib.splitString ":" m.hf)}/resolve/main/${m.mmproj}";
    }
    // lib.mapAttrs (_: renderValue) m.settings;
in
{
  options.modules.llama-cpp = {
    enable = lib.mkEnableOption "llama.cpp server with models pulled from Hugging Face";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.llama-cpp;
      description = "The llama-cpp package to use.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 9931;
    };

    ui = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Serve the built-in web UI of the main server (--ui / --no-ui). The API stays available either way.";
    };

    keepAlive = lib.mkOption {
      type = lib.types.nullOr lib.types.ints.positive;
      default = 600;
      description = "Seconds of inactivity before the model is unloaded from memory. null keeps it loaded.";
    };

    modelsMax = lib.mkOption {
      type = lib.types.ints.positive;
      default = 1;
      description = "Maximum number of models loaded at the same time (--models-max). Use 2 to keep the chat model and an embedding model resident together.";
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "File with HF_TOKEN=... for gated repositories.";
    };

    models = lib.mkOption {
      default = { };
      description = "GGUF models from Hugging Face. The attribute name is the model name in the API.";
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            hf = lib.mkOption {
              type = lib.types.str;
              example = "unsloth/Qwen3-Coder-Next-GGUF:Q4_K_XL";
              description = "Hugging Face repository, optionally with a quant tag (user/repo[:quant]).";
            };
            file = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Exact GGUF file in the repository (instead of a quant tag).";
            };
            mmproj = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Vision projector file in the same repository (enables image input).";
            };
            settings = lib.mkOption {
              type =
                with lib.types;
                attrsOf (oneOf [
                  str
                  int
                  float
                  bool
                ]);
              default = { };
              description = "Per-model llama-server flags without dashes; override the defaults.";
            };
          };
        }
      );
    };
  };

  config = lib.mkIf cfg.enable {
    services.llama-cpp = {
      enable = true;
      package = cfg.package;
      port = cfg.port;
      extraFlags = [
        (if cfg.ui then "--ui" else "--no-ui")
        "--models-max"
        (toString cfg.modelsMax)
      ]
      ++ lib.optionals (cfg.keepAlive != null) [
        "--sleep-idle-seconds"
        (toString cfg.keepAlive)
      ];
      modelsPreset = {
        "*" = defaults;
      }
      // lib.mapAttrs modelPreset cfg.models;
    };

    systemd.services.llama-cpp.serviceConfig = lib.mkIf (cfg.environmentFile != null) {
      EnvironmentFile = cfg.environmentFile;
    };

    environment.systemPackages = [ cfg.package ];
  };
}
