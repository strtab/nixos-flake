{
  programs.bat = {
    enable = true;
  };

  home.sessionVariables = {
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    MANROFFOPT = "-c";
  };

  home.shellAliases = {
    "cpuinfo" = "bat -l cpuinfo /proc/cpuinfo";
    "dfc" = "df -h -x tmpfs -x devtmpfs -x efivarfs | bat --style=plain -l help";
  };
}
