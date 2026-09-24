{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modules.services.v2raya;
  v2rayaOverride = pkgs.v2raya.overrideAttrs (old: rec {
    version = "2.2.7.5";

    src = pkgs.fetchFromGitHub {
      owner = "v2rayA";
      repo = "v2rayA";
      tag = "v${version}";
      hash = "sha256-aa/Eb+fZQ1hwm6H7wb7mr0b4tCu12Mhy14OXNjZUJ0Y=";
      postFetch = "sed -i -e 's/npmmirror/yarnpkg/g' $out/gui/yarn.lock";
    };

    # update web derivation with new src/hashes
    passthru = old.passthru // {
      web = old.passthru.web.overrideAttrs (_: {
        inherit src version;
        offlineCache = pkgs.fetchYarnDeps {
          yarnLock = "${src}/gui/yarn.lock";
          hash = "sha256-g+hI9n+nfXAcuEpjvDDaHg/DfjtNusOaw3S6kC1QDn4=";
        };
      });
    };

    vendorHash = "sha256-uiURsB1V4IB77YKLu5gdaqw9Fuja6fC5adWYDE3OE+Q=";

    # embed updated web build
    preBuild = ''
      cp -a ${passthru.web} server/router/web
    '';

    ldflags = [
      "-s"
      "-w"
      "-X github.com/v2rayA/v2rayA/conf.Version=${version}"
    ];
  });

  # cli backend override, same role as services.v2raya.cliPackage upstream
  package = v2rayaOverride.override { v2ray = pkgs.xray; };
in
{
  options.modules.services.v2raya = {
    enable = lib.mkEnableOption "v2raya";
    autoStart = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to start v2raya automatically at boot";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ package ];

    # inlined from nixpkgs services.v2raya module, so it only exists
    # while modules.services.v2raya.enable is true and doesn't need
    # nixpkgs' services.v2raya module imported at all
    systemd.services.v2raya =
      let
        nftablesEnabled = config.networking.nftables.enable;
        iptablesServices = [
          "iptables.service"
        ]
        ++ lib.optional config.networking.enableIPv6 "ip6tables.service";
        tableServices = if nftablesEnabled then [ "nftables.service" ] else iptablesServices;
      in
      {
        unitConfig = {
          Description = "v2rayA service";
          Documentation = "https://github.com/v2rayA/v2rayA/wiki";
          After = [
            "network.target"
            "nss-lookup.target"
          ]
          ++ tableServices;
          Wants = [ "network.target" ];
        };

        serviceConfig = {
          User = "root";
          ExecStart = "${lib.getExe package} --log-disable-timestamp";
          Environment = [ "V2RAYA_LOG_FILE=/var/log/v2raya/v2raya.log" ];
          LimitNPROC = 500;
          LimitNOFILE = 1000000;
          Restart = "on-failure";
          Type = "simple";
        };

        wantedBy = lib.mkIf cfg.autoStart [ "multi-user.target" ];
        path =
          with pkgs;
          [
            iptables
            bash
            iproute2
          ]
          ++ lib.optionals nftablesEnabled [ nftables ]; # required by v2rayA TProxy functionality
      };

    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.systemd1.manage-units" &&
            action.lookup("unit") == "v2raya.service") {
          return polkit.Result.YES;
        }
      });
    '';
  };
}
