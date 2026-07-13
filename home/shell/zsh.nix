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
      save = 500000;
      size = 500000;
    };
    initContent = ''
      PROMPT='%n@%m %1~ %# '

      # Emacs keybinds
      bindkey -e

      # Edit command line
      autoload -z edit-command-line
      zle -N edit-command-line
      bindkey "^E" edit-command-line

      # Use cache
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"

      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z} m:{A-Z}={a-z}'

      ${lib.optionalString config.programs.bat.enable ''
        alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
      ''};

      if (( COLUMNS > 100 )); then 
        cat << 'EOF' > /dev/stdout
      ▲
      __  __                                     _            __
      \ \/ /___  __  __   _________ _____       (_)_  _______/ /_
       \  / __ \/ / / /  / ___/ __ `/ __ \     / / / / / ___/ __/
       / / /_/ / /_/ /  / /__/ /_/ / / / /    / / /_/ (__  ) /_/
       _/\____/\__,_/   \___/\__,_/_/ /_/  __/ /\__,_/____/\__/
               __    _          __  __    /___/
         _____/ /_  (_)___     / /_/ /_  (_)___  ____ ______
        / ___/ __ \/ / __ \   / __/ __ \/ / __ \/ __ `/ ___/
       (__  ) / / / / /_/ /  / /_/ / / / / / / / /_/ (__  )
      /____/_/ /_/_/ .___/   \__/_/ /_/_/_/ /_/\__, /____/
                  /_/                         /____/

      EOF
      fi
    '';
  };
}
