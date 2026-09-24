{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.modules.services.dnscrypt-proxy;
  dns_blocklist = pkgs.writeText "blocklist.txt" ''
    ${builtins.readFile inputs.hagezi_pro}
    ${builtins.readFile inputs.hagezi_piracy}
  '';
in
{
  options.modules.services.dnscrypt-proxy.enable = lib.mkEnableOption "enable dnscrypt proxy";

  config = lib.mkIf cfg.enable {
    networking.networkmanager.dns = lib.mkDefault "none";
    services.dnscrypt-proxy = {
      enable = true;
      settings = {
        sources.public-resolvers = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
            "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
          ];
          # See https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
          cache_file = "/var/lib/dnscrypt-proxy/public-resolvers.md";
        };

        blocked_names.blocked_names_file = dns_blocklist;
        block_ipv6 = true;

        require_dnssec = true;
        require_nolog = false;
        require_nofilter = true;
      };
    };

    systemd.services.dnscrypt-proxy.serviceConfig."dnscrypt-proxy" = "dnscrypt-proxy";

    environment.systemPackages = with pkgs; [ knot-dns ];
  };
}
