{ lib, ... }:
{
  config = {
    var = {
      hostname = "moonveil";
      username = "user";
      fullname = "Maleshko Daniil";
      timezone = "Europe/Moscow";

      git = {
        enable = true;
        username = "strtab";
        email = "maleshkodaniil@gmail.com";
        useSecrets = true;
      };
    };
  };

  options = {
    # Create "var" option witch can contain any variables.
    var = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
  };
}
