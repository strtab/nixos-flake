{
  lib,
  config,
  ...
}:
{
  options.modules.services.smartd = {
    enable = lib.mkEnableOption "Enable smartd" // {
      default = true;
    };
  };

  config = lib.mkIf config.modules.services.smartd.enable {
    services.smartd = {
      enable = true;
    };
  };
}
