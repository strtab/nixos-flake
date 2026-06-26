{ pkgs, ... }:
let
  sf-pro = pkgs.stdenv.mkDerivation {
    pname = "San-Francisco Pro";
    version = "1.0.0";

    src = pkgs.fetchFromGitHub {
      owner = "sahibjotsaggu";
      repo = "San-Francisco-Pro-Fonts";
      rev = "8bfea09aa6f1139479f80358b2e1e5c6dc991a58";
      hash = "sha256-mAXExj8n8gFHq19HfGy4UOJYKVGPYgarGd/04kUIqX4=";
    };

    nativeBuildInputs = [ pkgs.unzip ];

    unpackPhase = ''
      cp -r $src/* .
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/fonts/truetype
      for zip in *.zip; do ${pkgs.unzip}/bin/unzip -o "$zip"; done
      find . -name "*.ttf" -o -name "*.otf" | xargs -I{} cp {} $out/share/fonts/truetype/

      runHook postInstall
    '';

    meta = {
      description = "The entire collection of San Francisco Pro Fonts";
      homepage = "https://github.com/sahibjotsaggu/San-Francisco-Pro-Fonts";
    };
  };
in
{
  fonts.packages = [
    pkgs.googlesans-code
    pkgs.noto-fonts
    sf-pro
  ];
}
