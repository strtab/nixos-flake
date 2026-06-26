{ config, ... }:
{
  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    history = {
      path = "${config.xdg.configHome}/zsh/histfile";
      save = 10000;
      size = 10000;
    };
    initContent = ''
      PROMPT='%n@%m %1~ %# '

      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z} m:{A-Z}={a-z}'
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
