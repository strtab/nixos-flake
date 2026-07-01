{ config, lib, ... }:
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

      # Edit command line
      autoload -z edit-command-line
      zle -N edit-command-line
      bindkey "^E" edit-command-line

      bindkey -e

      # Use cache
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"

      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z} m:{A-Z}={a-z}'

      ${lib.optionalString config.programs.bat.enable ''
        alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
      ''};
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
