{ pkgs
, lib
, config
, ...
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
  options._services.naiveproxy = {
    enable = lib.mkEnableOption "naive proxy";
    setVariables = lib.mkEnableOption "Use environment variables" // {
      default = true;
    };
    configSecret = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to agenix secret config file";
    };
    configDefault = lib.mkOption {
      type = lib.types.attrs;
      default = {
        listen = [
          "socks://127.0.0.1:1080"
          "http://127.0.0.1:8080"
        ];
        proxy = "https://user:pass@domain.example";
        log = "/var/log/naiveproxy.log";
      };
      description = "NaiveProxy configuration (used if configSecret is null)";
    };
  };

  config = lib.mkIf config._services.naiveproxy.enable {
    environment.systemPackages = [ naiveproxyPkg ];

    systemd.services.naiveproxy = {
      description = "NaiveProxy client";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${naiveproxyPkg}/bin/naive /etc/naiveproxy/config.json";
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

    environment.sessionVariables = lib.mkIf config._services.naiveproxy.setVariables {
      SOCKS_SERVER = "localhost:10808";
      SOCKS_VERSION = "5";
      no_proxy = "localhost,127.0.0.1,localaddress,.localdomain.com,stationx.mo,drweb.com,lo,anilib.me,kodikplayer.com,homelab,anilib.me,.ru,video1.cdnlibs.org,translate.yandex.com,vk.com,userapi.com,aeza.ru,.lan";
    };

    system.activationScripts.naiveproxyConfig = lib.mkIf (config._services.naiveproxy.configSecret == null) (
      let
        configFile = pkgs.writeText "config.json" (builtins.toJSON config._services.naiveproxy.configDefault);
      in
      ''
        mkdir -p /etc/naiveproxy
        cp ${configFile} /etc/naiveproxy/config.json
      ''
    );
  };
}
