{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modules.virt-manager;
in
{
  options.modules.virt-manager = {
    enable = lib.mkEnableOption "enable virt-manager";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
    users.users."${config.var.username}".extraGroups = [ "libvirtd" ];
  };
}
