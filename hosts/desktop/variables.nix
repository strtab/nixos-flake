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
        useCredentialsFromSecrets = true;
      };
    };
  };

  options = {
    var = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
  };
}
