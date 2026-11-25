{ pkgs, lib, ... }:
let
  # Default command executed after login
  session = "start-hyprland 2>/dev/null";
in
{
  environment.systemPackages = [ pkgs.tuigreet ];

  services.greetd = {
    enable = true;
    settings.default_session = {
      user = "greeter";
      command = lib.concatStringsSep " " [
        (lib.getExe' pkgs.tuigreet "tuigreet")
        "--time"
        "--remember"
        "--width 40"
        "--asterisks"
        "--cmd"
        (lib.escapeShellArg session)
        "2>/dev/null"
      ];
    };
  };
}
