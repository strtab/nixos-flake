{
  pkgs,
  lib,
  config,
  ...
}:
{
  # systemd.services.console-font-double = lib.mkIf config.modules.tty.doubledFont {
  #   description = "Set doubled console font";
  #   after = [ "systemd-vconsole-setup.service" ];
  #   wantedBy = [ "multi-user.target" ];
  #   serviceConfig = {
  #     Type = "oneshot";
  #     RemainAfterExit = true;
  #     ExecStart = "${pkgs.kbd}/bin/setfont ${config.modules.tty.font} -d";
  #   };
  # };
  console = {
    font = "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";
    packages = [ pkgs.terminus_font ];
    colors = [
      "000000"
      "D14D41"
      "879A39"
      "D0A215"
      "606060"
      "CE5D97"
      "ADBD60"
      "F2F0E5"
      "6F6E69"
      "D14D41"
      "879A39"
      "D0A215"
      "606060"
      "CE5D97"
      "ADBD60"
      "F2F0E5"
    ];
  };
}
