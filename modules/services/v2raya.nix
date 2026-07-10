{ pkgs, lib, config, ... }:
let
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
in
{
  options.modules.services.v2raya = {
    enable = lib.mkEnableOption "v2raya";
  };

  config = lib.mkIf config.modules.services.v2raya.enable {
    services.v2raya = {
      enable = true;
      package = v2rayaOverride;
      cliPackage = pkgs.xray;
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
