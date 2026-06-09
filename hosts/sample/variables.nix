{ lib, ... }:
{
  config.var = {
    hostname = "nixos";
    username = "user";
  };

  # DON'T TOUCH THIS
  options.var = lib.mkOption {
    type = lib.types.attrs;
    default = { };
  };
}
