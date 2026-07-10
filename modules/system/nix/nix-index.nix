{ lib, config, ... }:
{
  options.modules.nix.index.enable = lib.mkEnableOption "nix index database" // {
    default = true;
  };
  config = lib.mkIf config.modules.nix.index.enable {
    programs = {
      nix-index-database.comma.enable = true;
      nix-index.enable = true; # This is required for the nix-index-database to work, but it also provides a nice CLI for searching for packages
      nix-index.enableZshIntegration = false;
    };
  };
}
