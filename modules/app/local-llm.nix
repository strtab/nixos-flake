{
  pkgs-unstable,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.modules.local-llm;
in
{
  options.modules.local-llm = {
    enable = lib.mkEnableOption "Whether to enable ollama server and claude-code for local large language models.";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.ollama;
      description = "The ollama package to use. Different packages use different hardware acceleration.";
    };
    contextLength = lib.mkOption {
      type = lib.types.str;
      default = "64000";
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
      "llmlight" =
        "ollama launch claude --model ${cfg.defaultModel} -- --tools \"Read,Edit,Write,Bash,Grep,Glob,AskUserQuestion,WebFetch,WebSearch\" --no-chrome ";
    };

    environment.sessionVariables = {
      CLAUDE_CODE_MAX_CONTEXT_TOKENS = cfg.contextLength;
      CLAUDE_CODE_MAX_OUTPUT_TOKENS = "64000";
      CLAUDE_CODE_DISABLE_UNKNOWN_MODEL_WINDOW_ENFORCEMENT = "1";
    };

    environment.systemPackages = with pkgs-unstable; [ claude-code ];

    systemd.services.ollama.serviceConfig.ExecStartPre = lib.mkIf cfg.waitForNvidiaGpu [
      "${pkgs.bash}/bin/bash -c 'for i in $(seq 1 60); do [ -e /dev/nvidia0 ] && [ -e /dev/nvidiactl ] && exit 0; sleep 1; done; exit 1'"
    ];

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
