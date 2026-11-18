# ---------------------------------------------------------------
# Usage
# ---------------------------------------------------------------
#
# modules.llama-cpp = {
#   enable = true;
#   package = llama-cpp-pascal;
#   keepAlive = null; # Keep models loaded
#   ui = false; # disable the built-in web UI of the main server
#
#   # separate embedding server (used by RAG tools such as pi-semsearch)
#   embedding = {
#     hf = "Qwen/Qwen3-Embedding-4B-GGUF:Q8_0"; # switch the model here
#     gpuLayers = 99; # layers on the GPU, 0 = CPU only (default)
#     keepAlive = 30;
#     settings.threads = 8; # any extra llama-server flag without dashes
#   };
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
# };
#
# Models are downloaded from Hugging Face on first request into
# /var/cache/llama-cpp and selected by name in the API "model" field.
#
# After changing the embedding model, update "dimensions" in the
# semsearch config (the vector size differs between models) and
# re-index. The check script prints the real dimension.

{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.modules.llama-cpp;
  emb = cfg.embedding;

  # defaults for every model (override via `settings`)
  defaults = {
    flash-attn = "on";
    load-mode = "none";
  };

  renderValue = v: if builtins.isBool v then (if v then "on" else "off") else toString v;

  # command line rendering: true -> bare flag, false -> omitted
  renderFlags =
    flags:
    lib.concatLists (
      lib.mapAttrsToList (
        name: v: if builtins.isBool v then lib.optional v "--${name}" else [ "--${name}" (toString v) ]
      ) flags
    );

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

  embeddingArgs = [
    "-hf"
    emb.hf
    "--host"
    "127.0.0.1"
    "--port"
    (toString emb.port)
    "--embedding"
    "--pooling"
    emb.pooling
    "-ub"
    (toString emb.ubatch)
    "-ngl"
    (toString emb.gpuLayers)
  ]
  ++ lib.optionals (emb.file != null) [
    "--hf-file"
    emb.file
  ]
  ++ lib.optionals (emb.keepAlive != null) [
    "--sleep-idle-seconds"
    (toString emb.keepAlive)
  ]
  ++ renderFlags emb.settings;

  flagType =
    with lib.types;
    attrsOf (oneOf [
      str
      int
      float
      bool
    ]);
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

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "File with HF_TOKEN=... for gated repositories.";
    };

    embedding = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Run a separate embedding server (the main server cannot serve embeddings while --models-max is 1).";
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = cfg.package;
        defaultText = lib.literalExpression "config.modules.llama-cpp.package";
        description = "llama-cpp package for the embedding server.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 9932;
        description = "Must match the base URL in the client config (for example semsearch.json).";
      };

      hf = lib.mkOption {
        type = lib.types.str;
        default = "Qwen/Qwen3-Embedding-0.6B-GGUF:Q8_0";
        example = "Qwen/Qwen3-Embedding-4B-GGUF:Q8_0";
        description = "Hugging Face repository of the embedding model, optionally with a quant tag.";
      };

      file = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Exact GGUF file in the repository (instead of a quant tag).";
      };

      pooling = lib.mkOption {
        type = lib.types.enum [
          "none"
          "mean"
          "cls"
          "last"
          "rank"
        ];
        default = "last";
        description = "Pooling type. Qwen3-Embedding needs last, many BERT-style models need mean or cls.";
      };

      ubatch = lib.mkOption {
        type = lib.types.ints.positive;
        default = 8192;
        description = "Physical batch size. An input longer than this many tokens is rejected, so it limits the chunk length.";
      };

      gpuLayers = lib.mkOption {
        type = lib.types.ints.unsigned;
        default = 0;
        description = "Layers of the embedding model offloaded to the GPU. 0 runs it on the CPU.";
      };

      keepAlive = lib.mkOption {
        type = lib.types.nullOr lib.types.ints.positive;
        default = 30;
        description = "Seconds of inactivity before the model is unloaded. null keeps it loaded.";
      };

      settings = lib.mkOption {
        type = flagType;
        default = { };
        description = "Extra llama-server flags without dashes. A true value becomes a bare flag, false is omitted.";
      };
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
    assertions = [
      {
        assertion = !emb.enable || emb.port != cfg.port;
        message = "modules.llama-cpp.embedding.port must differ from modules.llama-cpp.port";
      }
    ];

    services.llama-cpp = {
      enable = true;
      package = cfg.package;
      port = cfg.port;
      extraFlags = [
        (if cfg.ui then "--ui" else "--no-ui")
        "--models-max"
        "1"
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

    systemd.user.services.llama-embed = lib.mkIf emb.enable {
      description = "llama.cpp embedding server";
      after = [ "network-online.target" ];
      wantedBy = [ "default.target" ];
      serviceConfig = {
        ExecStart = "${emb.package}/bin/llama-server ${lib.escapeShellArgs embeddingArgs}";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };

    systemd.services.llama-cpp.serviceConfig = lib.mkIf (cfg.environmentFile != null) {
      EnvironmentFile = cfg.environmentFile;
    };

    environment.systemPackages = [ cfg.package ];
  };
}
