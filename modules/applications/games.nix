{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.modules.games = {
    enable = lib.mkEnableOption "Enable games";
  };
  config = lib.mkIf config.modules.games.enable {
    programs = {
      steam.enable = true;
    };

    environment.systemPackages = with pkgs; [
      nwjs # Launch rmmz games
    ];
  };
}
