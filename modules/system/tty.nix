{ pkgs, lib, config, ... }:
{
  options.tty = {
    doubledFonts = lib.mkEnableOption "Set doubled tty font";
    font = lib.mkOption {
      type = lib.types.str;
      default = "viscii10-8x16";
    };
  };
  config = {
    systemd.services.console-font-double = {
      description = "Set doubled console font";
      after = [ "systemd-vconsole-setup.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.kbd}/bin/setfont ${config.tty.font} -d";
      };
    };
    console = {
      font = config.tty.font;
      colors = [
        "000000"
        "c34043"
        "76946a"
        "c0a36e"
        "859fac"
        "957fb8"
        "6a9589"
        "c8c093"
        "727169"
        "e82424"
        "98bb6c"
        "e6c384"
        "859fac"
        "938aa9"
        "7aa89f"
        "dcd7ba"
      ];
    };
  };
}
