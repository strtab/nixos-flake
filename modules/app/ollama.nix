# ---------------------------------------------------------------
# Usage
# ---------------------------------------------------------------
#
# modules.ollama.customModels."qwen-coder-autocomplete" = {
#   from = "qwen2.5-coder:7b-base";
#   parameters = {
#     temperature = 0.1;
#     top_p = 0.9;
#     num_ctx = 4096;
#     num_predict = 128;
#     stop = [
#       "<|fim_prefix|>"
#       "<|fim_suffix|>"
#       "<|fim_middle|>"
#       "<|file_sep|>"
#       "<|endoftext|>"
#     ];
#   };
# };
#
# modules.ollama.customModels."qwen-agent" = {
#   from = "fredrezones55/Qwen3.6-35B-A3B-Uncensored-HauhauCS-Aggressive:q4";
#   parameters = { temperature = 0.6; num_ctx = 128000; };
#   system = "You are a concise coding assistant.";
# };
#
# Raw Modelfile instead of structured options:
#
# modules.ollama.customModels."raw-example".modelfile = ''
#   FROM qwen2.5-coder:1.5b
#   PARAMETER temperature 0.2
# '';

{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.modules.ollama;
  ollama = lib.getExe cfg.package;

  # Succeeds only when CUDA is really usable, not just when device nodes exist
  waitForGpu = pkgs.writeShellScript "ollama-wait-nvidia" ''
    for i in $(seq 1 90); do
      if [ -e /dev/nvidiactl ] \
        && [ -e /dev/nvidia-uvm ] \
        && ${config.hardware.nvidia.package.bin}/bin/nvidia-smi -L >/dev/null 2>&1; then
        exit 0
      fi
      sleep 2
    done
    echo "NVIDIA GPU is not ready" >&2
    exit 1
  '';

  # Render a Modelfile from the structured options
  renderModelfile =
    m:
    (lib.concatStringsSep "\n" (
      [ "FROM ${m.from}" ]
      ++ lib.concatLists (
        lib.mapAttrsToList (k: v: map (x: "PARAMETER ${k} ${toString x}") (lib.toList v)) m.parameters
      )
      ++ lib.optional (m.template != null) ''TEMPLATE """${m.template}"""''
      ++ lib.optional (m.system != null) ''SYSTEM """${m.system}"""''
      ++ lib.optional (m.extraConfig != "") m.extraConfig
    ))
    + "\n";

  # Model names may contain ':' or '/', which are invalid in store paths
  modelfiles = lib.mapAttrs (
    name: m: pkgs.writeText "Modelfile-${lib.strings.sanitizeDerivationName name}" m.modelfile
  ) cfg.customModels;
in
{
  options.modules.ollama = {
    enable = lib.mkEnableOption "Whether to enable ollama server and claude-code for local large language models.";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.ollama;
      description = "The ollama package to use. Different packages use different hardware acceleration.";
    };
    contextLength = lib.mkOption {
      type = lib.types.str;
      default = "128000";
    };
    defaultModel = lib.mkOption {
      type = lib.types.str;
      default = "fredrezones55/Qwen3.6-35B-A3B-Uncensored-HauhauCS-Aggressive:q4";
      description = "The primary model to use.";
    };
    keepAlive = lib.mkOption {
      type = lib.types.str;
      default = "5m";
    };
    waitForNvidiaGpu = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    customModels = lib.mkOption {
      default = {
      };
      description = ''
        Models built with `ollama create` from a Modelfile.
        Built by `ollama-model-builder.service`, which retries with backoff on failure
        (for example on an interrupted download of the `FROM` model).
      '';
      type = lib.types.attrsOf (
        lib.types.submodule (
          { config, ... }:
          {
            options = {
              from = lib.mkOption {
                type = lib.types.str;
                example = "qwen2.5-coder:7b-base";
                description = "Base model (FROM). Pulled automatically if missing.";
              };
              parameters = lib.mkOption {
                type =
                  with lib.types;
                  attrsOf (oneOf [
                    str
                    int
                    float
                    (listOf (oneOf [
                      str
                      int
                      float
                    ]))
                  ]);
                default = { };
                example = {
                  temperature = 0.1;
                  num_ctx = 4096;
                  stop = [
                    "<|fim_prefix|>"
                    "<|endoftext|>"
                  ];
                };
                description = "PARAMETER entries. A list produces one PARAMETER line per element.";
              };
              system = lib.mkOption {
                type = lib.types.nullOr lib.types.lines;
                default = null;
                description = "SYSTEM prompt.";
              };
              template = lib.mkOption {
                type = lib.types.nullOr lib.types.lines;
                default = null;
                description = "TEMPLATE override.";
              };
              extraConfig = lib.mkOption {
                type = lib.types.lines;
                default = "";
                description = "Raw lines appended to the Modelfile (ADAPTER, MESSAGE, LICENSE, ...).";
              };
              modelfile = lib.mkOption {
                type = lib.types.lines;
                default = renderModelfile config;
                defaultText = "generated from the options above";
                description = "Final Modelfile. Set it directly to bypass the structured options.";
              };
            };
          }
        )
      );
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.ollama = lib.mkIf cfg.waitForNvidiaGpu {
      after = [
        "systemd-modules-load.service"
        "nvidia-persistenced.service"
      ];
      wants = [ "nvidia-persistenced.service" ];
      serviceConfig = {
        # Default 90s is shorter than the wait loop, the unit would be killed
        TimeoutStartSec = "240";
        ExecStartPre = [ "${waitForGpu}" ];
      };
    };

    # Same pattern as nixpkgs' ollama-model-loader: separate DynamicUser unit,
    # bound to ollama.service, retried with bounded exponential backoff.
    systemd.services.ollama-model-builder = lib.mkIf (cfg.customModels != { }) {
      description = "Build custom ollama models from Modelfiles";
      wantedBy = [
        "multi-user.target"
        "ollama.service"
      ];
      wants = [ "network-online.target" ];
      after = [
        "ollama.service"
        "network-online.target"
      ];
      bindsTo = [ "ollama.service" ];
      # Rebuild models on `nixos-rebuild switch` when a Modelfile changes
      restartTriggers = lib.attrValues modelfiles;
      environment = config.systemd.services.ollama.environment;
      serviceConfig = {
        Type = "exec";
        DynamicUser = true;
        # Stay "active" after success so restartTriggers take effect on switch
        RemainAfterExit = true;
        Restart = "on-failure";
        RestartSec = "1s";
        RestartMaxDelaySec = "2h";
        RestartSteps = "10";
      };
      script = ''
        set -eu

        # Wait for the API to come up
        for i in $(seq 1 60); do
          '${ollama}' list >/dev/null 2>&1 && break
          sleep 1
        done

        ${lib.concatStringsSep "\n" (
          lib.mapAttrsToList (
            name: file: "'${ollama}' create ${lib.escapeShellArg name} -f ${file}"
          ) modelfiles
        )}
      '';
    };

    services.ollama = {
      enable = true;
      package = cfg.package;
      environmentVariables = {
        OLLAMA_FLASH_ATTENTION = "1";
        OLLAMA_CONTEXT_LENGTH = cfg.contextLength;
        OLLAMA_KV_CACHE_TYPE = "q8_0";
        OLLAMA_NUM_PARALLEL = "1";
        OLLAMA_KEEP_ALIVE = cfg.keepAlive;
        OLLAMA_NO_CLOUD = "1";
      };
      # Do NOT list custom models or their FROM models here: `ollama create` pulls FROM itself
      loadModels = [
        cfg.defaultModel
      ];
    };
  };
}
