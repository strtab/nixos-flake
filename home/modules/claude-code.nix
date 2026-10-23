{ config, ... }:
let
  configDir = "${config.xdg.configHome}/claude";
in
{
  home.sessionVariables = {
    "CLAUDE_CONFIG_DIR" = configDir;
  };
  home.file."${configDir}/CLAUDE.md" = {
    text = ''
      Don't use emoji and unicode symbols.
      Use web search for quickly updated topics.
      Write comments in the code only in English.
    '';
  };
  programs.claude-code = {
    enable = true;
    configDir = configDir;
    settings = {
      permissions = {
        allow = [
          "Read"
          "WebFetch"
          "WebSearch"
        ];
        deny = [
          "Read(./.env)"
          "Read(./secrets/**)"
        ];
      };
      statusLine = {
        type = "command";
        command = "${configDir}/statusline.sh";
        padding = 0;
      };
      effort = "auto";
      theme = "dark-ansi";
      editorMode = "normal";
      preferredNotifChannel = "auto";
      spinnerTipsEnabled = false;
      switchModelsOnFlag = false;
      useAutoModeDuringPlan = false;
      promptSuggestionEnabled = false;
      terminalProgressBarEnabled = true;
    };
    lspServers = {
      go = {
        command = "gopls";
        args = [
          "serve"
        ];
        extensionToLanguage = {
          ".go" = "go";
        };
      };
      nix = {
        command = "nil";
        extensionToLanguage = {
          ".nix" = "nix";
        };
      };
      bash = {
        command = "bash-language-server";
        args = [
          "start"
        ];
        extensionToLanguage = {
          ".bash" = "bash";
          ".sh" = "bash";
        };
      };
      yaml = {
        command = "yaml-language-server";
        args = [ "--stdio" ];
        extensionToLanguage = {
          ".yaml" = "yaml";
          ".yml" = "yaml";
        };
      };
      lua = {
        command = "lua-language-server";
        extensionToLanguage = {
          ".lua" = "lua";
        };
      };
    };
  };
  home.file."${configDir}/statusline.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # Read all of stdin into a variable
      input=$(cat)

      # Extract fields with jq, "// 0" provides fallback for null
      MODEL=$(echo "$input" | jq -r '.model.display_name')
      COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
      PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

      COST_FMT=$(printf '$%.2f' "$COST")

      GREEN='\033[32m'
      YELLOW='\033[33m'
      RED='\033[31m'
      RESET='\033[0m'

      # Pick bar color based on context usage
      if [ "$PCT" -ge 90 ]; then BAR_COLOR="$RED"
      elif [ "$PCT" -ge 70 ]; then BAR_COLOR="$YELLOW"
      else BAR_COLOR="$GREEN"; fi

      # Build progress bar: printf -v creates a run of spaces, then
      # the substitution replaces each space with a bar character
      BAR_WIDTH=13
      FILLED=$((PCT * BAR_WIDTH / 100))
      EMPTY=$((BAR_WIDTH - FILLED))
      BAR=""
      [ "$FILLED" -gt 0 ] && printf -v FILL "%''${FILLED}s" && BAR="''${FILL// /#}"
      [ "$EMPTY" -gt 0 ] && printf -v PAD "%''${EMPTY}s" && BAR="''${BAR}''${PAD// /-}"

      if git rev-parse --git-dir >/dev/null 2>&1; then
        BRANCH=$(git branch --show-current 2>/dev/null)
        STAGED=$(git diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
        MODIFIED=$(git diff --numstat 2>/dev/null | wc -l | tr -d ' ')

        GIT_STATUS=""
        [ "$STAGED" -gt 0 ] && GIT_STATUS="''${GREEN}+''${STAGED}''${RESET}"
        [ "$MODIFIED" -gt 0 ] && GIT_STATUS="''${GIT_STATUS}''${YELLOW}~''${MODIFIED}''${RESET}"

        echo -e "[$MODEL] ''${BAR_COLOR}[''${BAR}]''${RESET} ''${PCT}% | $COST_FMT | $BRANCH $GIT_STATUS"
      else
        echo -e "[$MODEL] ''${BAR_COLOR}[''${BAR}]''${RESET} ''${PCT}% | $COST_FMT"
      fi
    '';
  };
}
