{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modules.local-llm;
in
{
  options.modules.local-llm = {
    enable = lib.mkEnableOption "local ollama and claude code";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.ollama-cuda.override { cudaArches = [ "61" ]; };
      defaultText = lib.literalExpression ''pkgs.ollama-cuda.override { cudaArches = [ "61" ]; }'';
      description = "Ollama package to use";
    };
    contextLength = lib.mkOption {
      type = lib.types.str;
      default = "32768";
    };
    defaultModel = lib.mkOption {
      type = lib.types.str;
      default = "gemma4:26b";
    };
    keepAlive = lib.mkOption {
      type = lib.types.str;
      default = "5m";
    };
  };

  config = lib.mkIf cfg.enable {

    environment.shellAliases = {
      "llm" = "ollama launch claude --model ${cfg.defaultModel}";
      "llmlite" =
        "ollama launch claude --model ${cfg.defaultModel} -- --tools \"Read,Edit,Write,Bash,Grep,Glob\"";
    };

    environment.sessionVariables = {
      CLAUDE_CODE_MAX_CONTEXT_TOKENS = cfg.contextLength;
      CLAUDE_CODE_DISABLE_UNKNOWN_MODEL_WINDOW_ENFORCEMENT = "1";
    };

    environment.systemPackages = with pkgs; [ claude-code ];

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
