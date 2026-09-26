{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.modules.office.enable = lib.mkEnableOption "Enable office packages";
  config = lib.mkIf config.modules.office.enable {
    environment.systemPackages = with pkgs; [
      onlyoffice-desktopeditors
    ];
  };
}
