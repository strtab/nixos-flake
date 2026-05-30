{ lib, ... }:
{
  config.var = {
    hostname = "moonveil";
    username = "user";
  };

  # DON'T TOUCH THIS
  options.var = lib.mkOption {
    type = lib.types.attrs;
    default = { };
  };
}
