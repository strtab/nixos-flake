{ config , pkgs , lib , ... }:
{
  options.modules.wireshark = {
    enable = lib.mkEnableOption "Enable wireshark";
  };
  config = lib.mkIf config.modules.wireshark.enable {
    environment.systemPackages = with pkgs; [ wireshark ];
    users.users."${config.var.username}".extraGroups = [ "wireshark" ];
    programs = {
      wireshark = {
        enable = true;
        dumpcap.enable = true;
        usbmon.enable = true;
      };
    };
  };
}
