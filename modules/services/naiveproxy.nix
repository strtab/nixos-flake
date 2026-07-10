{ pkgs
, lib
, config
, inputs
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
  options.modules.services.naiveproxy = {
    enable = lib.mkEnableOption "naive proxy";
    setVariables = lib.mkEnableOption "Use environment variables" // {
      default = true;
    };
    useSecrets = lib.mkEnableOption "Use secret file for naive proxy";
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

  config = lib.mkIf config.modules.services.naiveproxy.enable {
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

    environment.sessionVariables = lib.mkIf config.modules.services.naiveproxy.setVariables {
      SOCKS_SERVER = "localhost:10808";
      SOCKS_VERSION = "5";
    };

    age.secrets.naiveproxy = lib.mkIf config.modules.services.naiveproxy.useSecrets {
      file = "${inputs.self}/secrets/naiveproxy.age";
      path = "/etc/naiveproxy/config.json";
      # owner = "naiveproxy";
      # group = "naiveproxy";
      symlink = false;
      mode = "444";
    };

    system.activationScripts.naiveproxyConfig =
      lib.mkIf (config.modules.services.naiveproxy.useSecrets == false)
        (
          let
            configFile = pkgs.writeText "config.json" (
              builtins.toJSON config.modules.services.naiveproxy.configDefault
            );
          in
          ''
            if [[ ! -f /etc/naiveproxy/config.json ]]; then 
              mkdir -p /etc/naiveproxy
              cp ${configFile} /etc/naiveproxy/config.json
            fi
          ''
        );
  };
}
