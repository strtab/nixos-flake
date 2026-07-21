{ ... }:
{
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
