{ pkgs, ... }:
{
  systemd.services.console-font-double = {
    description = "Set doubled console font";
    after = [ "systemd-vconsole-setup.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.kbd}/bin/setfont viscii10-8x16 -d";
    };
  };
  console = {
    font = "viscii10-8x16";
    colors = [
      "0F0D0B"
      "af4b00"
      "919922"
      "ca9f1d"
      "46867e"
      "b8616a"
      "6c9d66"
      "a59a84"
      "8f8473"
      "e16600"
      "b0bd2f"
      "ecc330"
      "85a593"
      "d88681"
      "91c07a"
      "d4be98"
    ];
  };
}
