{
  pkgs,
  lib,
  config,
  ...
}:
{
  console = {
    font = "${pkgs.terminus_font}/share/consolefonts/ter-v16n.psf.gz";
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
