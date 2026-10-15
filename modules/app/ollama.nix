{
  pkgs-unstable,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.modules.ollama;

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
  };

  config = lib.mkIf cfg.enable {
    environment.shellAliases = {
      "llm" = "ollama launch claude --model ${cfg.defaultModel}";
      "llmlite" =
        "ollama launch claude --model ${cfg.defaultModel} -- --tools \"Read,Edit,Write,Bash,Grep,Glob,AskUserQuestion,WebFetch,WebSearch\" --no-chrome ";
      "llmlight" = "llmlite";
    };

    environment.sessionVariables = {
      CLAUDE_CODE_MAX_CONTEXT_TOKENS = cfg.contextLength;
      CLAUDE_CODE_MAX_OUTPUT_TOKENS = "64000";
      CLAUDE_CODE_DISABLE_UNKNOWN_MODEL_WINDOW_ENFORCEMENT = "1";
    };

    environment.systemPackages = with pkgs-unstable; [ claude-code ];

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
      loadModels = [
        "qwen2.5-coder:1.5b"
        cfg.defaultModel
      ];
    };
  };
}
