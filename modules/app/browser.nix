{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
let
  heliumPkg = inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  config = lib.mkIf config.modules.common.enable {
    environment.systemPackages = [
      # lowPrio: gives us .desktop file + icons for the app menu,
      # while bin/helium collision is resolved in favor of the firejail wrapper below
      (lib.lowPrio heliumPkg)
    ];

    programs.firejail.wrappedBinaries.helium = {
      executable = "${heliumPkg}/bin/helium";
      # Firejail has no dedicated helium.profile yet, chromium.profile fits
      # since Helium is a Chromium fork
      profile = "${pkgs.firejail}/etc/firejail/chromium.profile";
      extraArgs = [
        # Required for U2F USB stick
        "--ignore=private-dev"
        # Enable Wayland mode
        "--env=NIXOS_OZONE_WL=1"
        # Enable system notifications
        "--dbus-user.talk=org.freedesktop.Notifications"
      ];
    };
  };
}
