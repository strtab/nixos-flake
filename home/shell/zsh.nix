{ config, ... }:
{
  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    history = {
      path = "${config.xdg.configHome}/zsh/histfile";
      save = 10000;
      size = 10000;
    };
    initContent = ''
      bindkey -v
      PROMPT='%n@%m %1~ %# '

      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z} m:{A-Z}={a-z}'
      # function command_not_found_handler {
      #   printf 'zsh: command not found: %s\n' "$1"
      #   return 127
      # }
    '';
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [
      "--height=10"
      "--preview-window=0"
      "--border=none"
      "--no-hscroll"
      "--marker=''"
      "--pointer=''"
      "--no-unicode"
    ];
  };
}
