{ lib, config, ... }:
{
  options.modules.nix.index.enable = lib.mkEnableOption "nix index database" // {
    default = true;
  };
  config = lib.mkIf config.modules.nix.index.enable {
    programs = {
      # This is required for the nix-index-database to work,
      # but it also provides `nix-locate` a nice CLI for searching packages.
      nix-index.enable = true;

      nix-index-database.comma.enable = true;
      nix-index.enableZshIntegration = false;
    };
  };
}
