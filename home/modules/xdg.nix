{ config, lib, ... }:
{
  xdg = {
    enable = true;
    autostart.enable = true;
    autostart.readOnly = true;
    terminal-exec.enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = true;
      download = "${config.home.homeDirectory}/Downloads";
      documents = "${config.home.homeDirectory}/Documents";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
      projects = "${config.home.homeDirectory}/Development";
      desktop = "${config.xdg.configHome}/Desktop";
      templates = "${config.xdg.configHome}/Templates";
      publicShare = "${config.xdg.configHome}/Public";
    };
  };

  home.sessionVariables = lib.mkOverride 10 {
    # cleaning up ~
    ANDROID_USER_HOME = "${config.xdg.dataHome}/android";
    BUN_INSTALL_GLOBAL_DIR = "${config.xdg.dataHome}/bun";
    BUN_INSTALL_BIN = "${config.home.homeDirectory}/.local/bin";
    CARGO_HOME = "${config.xdg.dataHome}/cargo";
    CUDA_CACHE_PATH = "${config.xdg.cacheHome}/nv";
    DOTNET_CLI_HOME = "${config.xdg.dataHome}/dotnet";
    GOPATH = "${config.xdg.dataHome}/go";
    GRADLE_USER_HOME = "${config.xdg.dataHome}/gradle";
    _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${config.xdg.configHome}/java";
    LESSHISTFILE = "${config.xdg.cacheHome}/less/history";
    MPLAYER_HOME = "${config.xdg.configHome}/mplayer";
    NODE_REPL_HISTORY = "${config.xdg.stateHome}/node_repl_history";
    NPM_CONFIG_INIT_MODULE = "${config.xdg.configHome}/npm/config/npm-init.js";
    NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm";
    NPM_CONFIG_PREFIX = "${config.xdg.stateHome}/npm";
    NXC_PATH = "${config.xdg.configHome}/nxc";
    NUGET_PACKAGES = "${config.xdg.cacheHome}/NuGetPackages";
    OCTAVE_HISTFILE = "${config.xdg.cacheHome}/octave-hsts";
    OCTAVE_SITE_INITFILE = "${config.xdg.configHome}/octave/octaverc";
    STACK_ROOT = "${config.xdg.dataHome}/stack";
    PI_CODING_AGENT_DIR = "${config.xdg.configHome}/pi/agent";
    PYTHON_HISTORY = "${config.xdg.configHome}/python/history";
    WINEPREFIX = "${config.xdg.dataHome}/wine";
    XCOMPOSECACHE = "${config.xdg.cacheHome}/X11/xcompose";
    _Z_DATA = "${config.xdg.dataHome}/z";
  };
}
