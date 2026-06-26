{ pkgs, lib, config, ... }:
{
  options.vial = {
    enable = lib.mkEnableOption "Enable vial";
  };
  config = lib.mkIf config.vial.enable {
    environment.systemPackages = with pkgs; [ vial ];
    services.udev = {
      packages = with pkgs; [
        qmk-udev-rules
        qmk_hid
        vial
        via
        qmk
      ];
    };
  };
}
