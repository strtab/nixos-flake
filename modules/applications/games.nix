{ pkgs, lib, config, ... }:
{
  options.games = {
    enable = lib.mkEnableOption "Enable games";
  };
  config = lib.mkIf config.games.enable {
    programs = {
      steam.enable = true;
    };

    environment.systemPackages = with pkgs; [
      nwjs # Launch rmmz games
    ];
  };
}
