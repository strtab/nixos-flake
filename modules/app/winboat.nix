{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.modules.winboat.enable = lib.mkEnableOption "Enable winboat";
  config = lib.mkIf config.modules.winboat.enable {
    nixpkgs.config.permittedInsecurePackages = [
      "electron-40.10.5"
    ];
    environment.systemPackages = with pkgs; [
      docker
      winboat
    ];
    users.users."${config.var.username}".extraGroups = [ "docker" ];
    virtualisation = {
      docker = {
        enable = true;
        autoPrune.enable = true;
      };
    };
  };
}
