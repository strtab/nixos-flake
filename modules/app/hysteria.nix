{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.modules.services.hysteria;

  hysteriaPkg = pkgs.stdenv.mkDerivation rec {
    pname = "hysteria";
    version = "2.12.1";
    src = pkgs.fetchurl (
      pkgs.lib.attrByPath [ pkgs.stdenv.hostPlatform.system ]
        (throw "hysteria.nix: unsupported system ${pkgs.system}")
        {
          "x86_64-linux" = {
            url = "https://github.com/apernet/hysteria/releases/download/app%2Fv${version}/hysteria-linux-amd64";
            hash = "sha256-/8Ayx8preGdtM3CXyn9hvrw6kKTzplZpOt82jzBM28c=";
          };
        }
    );

    nativeBuildInputs = [ pkgs.autoPatchelfHook ];

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      install -Dm755 $src $out/bin/hysteria
      runHook postInstall
    '';

    meta = {
      description = "hysteria client";
      homepage = "https://github.com/apernet/hysteria";
      mainProgram = "hysteria";
      license = lib.licenses.bsd3;
      platforms = [ "x86_64-linux" ];
    };
  };
in
{
  options.modules.services.hysteria = {
    enable = lib.mkEnableOption "hysteria client";

    setVariables =
      lib.mkEnableOption "Set environment variables for automatic use of the proxy client by applications"
      // {
        default = true;
      };

    useSecrets = lib.mkEnableOption "Use secret file for hysteria";

    configDefault = lib.mkOption {
      type = lib.types.lines;
      default = ''
        server: example.com:443
        auth: replace-me

        socks5:
          listen: 127.0.0.1:1080

        http:
          listen: 127.0.0.1:8080
      '';
      description = "hysteria client configuration (used if useSecrets is false)";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ hysteriaPkg ];

    systemd.services.hysteria = {
      description = "hysteria client";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${hysteriaPkg}/bin/hysteria -l warn --disable-update-check -c /etc/hysteria/config.yaml";
        Restart = "on-failure";
        RestartSec = "3s";
        DynamicUser = true;
        LimitNOFILE = 2048;
      };
    };

    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.systemd1.manage-units" &&
            action.lookup("unit") == "hysteria.service") {
          return polkit.Result.YES;
        }
      });
    '';

    environment.sessionVariables = lib.mkIf cfg.setVariables {
      SOCKS_SERVER = "127.0.0.1:1080";
      SOCKS_VERSION = "5";
      http_proxy = "http://127.0.0.1:8080";
      https_proxy = "http://127.0.0.1:8080";
    };

    age.secrets.hysteria = lib.mkIf cfg.useSecrets {
      file = "${inputs.self}/secrets/hysteria.age";
      path = "/etc/hysteria/config.yaml";
      symlink = false;
      mode = "444";
    };

    # Only write the default config when secrets are not in use.
    # Existing file is never overwritten, so local edits survive rebuilds.
    system.activationScripts.hysteriaConfig = lib.mkIf (!cfg.useSecrets) (
      let
        configFile = pkgs.writeText "config.yaml" cfg.configDefault;
      in
      ''
        mkdir -p /etc/hysteria
        if [[ ! -f /etc/hysteria/config.yaml ]]; then
          cp ${configFile} /etc/hysteria/config.yaml
        fi
      ''
    );
  };
}
