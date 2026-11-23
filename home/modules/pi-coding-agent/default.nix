{
  config,
  pkgs,
  inputs,
  ...
}:
let
  agentDir = "${config.xdg.configHome}/pi/agent";

  # merge several skill directories into one store path: <store>/<skill-name>/SKILL.md
  allSkills = pkgs.symlinkJoin {
    name = "pi-skills";
    paths = [
      "${inputs.obsidian-skills}/plugins/obsidian/skills"
      "${inputs.jakubkrehel-skills}/skills"
      "${inputs.ponytail-skills}/skills"
      ./skills # local skills
    ];
  };
in
{
  imports = [ inputs.pi-hm.homeModules.default ];

  home.packages = with pkgs; [
    html2text
    ffmpeg
    ddgr
  ];

  programs.pi-coding-agent = {
    enable = true;
    configDir = agentDir;

    rules = ''
      Don't use emoji and unicode symbols.
      Use web search for quickly updated topics.
      Write comments in the code only in English.
    '';

    extensions = [
      ./extensions/ask-user-question.ts
      ./extensions/prompt-snippets
      ./extensions/ddgr-search
      ./extensions/clear.tx # /clear
    ];

    skills = allSkills;
    keybindings = ./keybindings.json;

    settings = {
      enableInstallTelemetry = false;
      collapseChangelog = true;
      quietStartup = true;
      doubleEscapeAction = "tree";
      defaultThinkingLevel = "medium";
      hideThinkingBlock = false;
      compaction.enabled = true;
      images.blockImages = false;
      showHardwareCursor = true;
      terminal = {
        clearOnShrink = true;
        showTerminalProgress = true;
      };
      theme = "claude-code-dark";
      defaultProvider = "llama-server=http://127.0.0.1:9931";
      defaultModel = "HauhauCS/Qwen3.6-35B-A3B-Uncensored-HauhauCS-Aggressive:Q4_K_P";
      packages = [
        "git:github.com/strtab/pi-claude-code-ui"
        "npm:pi-prefix-cache-compaction"
        "npm:@jetserge/pi-clear-hotkey" # ctrl-l
        "npm:@juicesharp/rpiv-todo"
        "npm:pi-llama-cpp"
        "npm:pi-keyrouter"
        "npm:pi-guards"
      ];
    };

    environment.PI_SKIP_VERSION_CHECK = "1";
  };

  home.activation.linkPiAuth = config.lib.dag.entryAfter [ "setXdgRuntimeDir" ] ''
    mkdir -p "${agentDir}"

    ln -sf "${config.age.secrets.pi-auth.path}" "${agentDir}/auth.json"
    ln -sf "${config.age.secrets.pi-keyrouter.path}" "${agentDir}/keyrouter.json"

    chmod 600 "${agentDir}/auth.json" 2>/dev/null || true
    chmod 600 "${agentDir}/keyrouter.json" 2>/dev/null || true
  '';

  home.sessionVariables = {
    PI_SKIP_VERSION_CHECK = 1;
  };
}
