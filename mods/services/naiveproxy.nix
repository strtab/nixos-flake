{
  pkgs,
  lib,
  ...
}:
let
  naiveproxyPkg = pkgs.stdenv.mkDerivation rec {
    pname = "naiveproxy";
    version = "143.0.7499.109-2";
    src = pkgs.fetchurl (
      pkgs.lib.attrByPath [ pkgs.stdenv.hostPlatform.system ]
        (throw "naiveproxy.nix: unsupported system ${pkgs.system}")
        {
          "x86_64-linux" = {
            url = "https://github.com/klzgrad/naiveproxy/releases/download/v${version}/naiveproxy-v${version}-linux-x64.tar.xz";
            hash = "sha256-bFy8TAHns1MlUudhdHrnFi0K9KraTEiH86W7WwMpJfc=";
          };
        }
    );
    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    buildInputs = [ pkgs.nss ];
    sourceRoot = "naiveproxy-v${version}-linux-x64";
    dontBuild = true;
    installPhase = "install -Dm755 naive $out/bin/naive";
    meta = {
      description = "NaiveProxy client";
      homepage = "https://github.com/klzgrad/naiveproxy";
      mainProgram = "naive";
      license = lib.licenses.bsd3;
      platforms = [ "x86_64-linux" ];
    };
  };
in
{
  environment.systemPackages = [
    pkgs.tun2socks
    naiveproxyPkg
  ];

  systemd.services.naiveproxy = {
    description = "NaiveProxy client";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${naiveproxyPkg}/bin/naive /var/lib/naiveproxy/config.json";
      Restart = "on-failure";
      RestartSec = "3s";
      DynamicUser = true;
      LimitNOFILE = 2048;
    };
  };

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.systemd1.manage-units" &&
          action.lookup("unit") == "naiveproxy.service") {
        return polkit.Result.YES;
      }
    });
  '';

  environment.sessionVariables = {
    SOCKS_SERVER = "localhost:10808";
    SOCKS_VERSION = "5";
    all_proxy = "socks5://localhost:10808";
  };

  system.activationScripts.naiveproxyConfig = {
    text = ''
      if [ ! -f /var/lib/naiveproxy/config.json ]; then
        mkdir -p /var/lib/naiveproxy
        echo '{"listen":"socks://127.0.0.1:1080","proxy":"https://user:pass@server"}' > /var/lib/naiveproxy/config.json
      fi
    '';
  };
}
