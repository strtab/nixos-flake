{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.modules.helium;
  helium = inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default;
  # Carries only share/applications (.desktop file) and share/icons from the
  # original package, so environment.systemPackages doesn't fight the
  # firejail wrapper below over bin/helium. meta.priority = -1 makes buildEnv
  # resolve any remaining path collision in favor of this lower-priority package.
  heliumDesktopFiles =
    pkgs.runCommand "firejail-helium-desktop"
      {
        preferLocalBuild = true;
        allowSubstitutes = false;
        meta.priority = -1;
      }
      ''
        mkdir -p "$out/share"
        for dir in applications icons; do
          if [ -d "${helium}/share/$dir" ]; then
            tar -C "${helium}" -c "share/$dir" -h --mode 0755 -f - | tar -C "$out" -xf -
          fi
        done
        find "$out/" -type f -print0 | xargs -0 chmod 0444
        find "$out/" -type d -print0 | xargs -0 chmod 0555
      '';
in
{
  #   options.modules.helium.enable = lib.mkEnableOption "Enable helium browser";
  #   config = lib.mkIf cfg.enable {
  #     environment.systemPackages = [ heliumDesktopFiles ];
  #     programs.firejail.wrappedBinaries.helium = {
  #       executable = "${helium}/bin/helium";
  #       # Firejail has no dedicated helium.profile yet, chromium.profile fits
  #       # since Helium is a Chromium fork
  #       profile = "${pkgs.firejail}/etc/firejail/chromium.profile";
  #       extraArgs = [
  #         # Required for U2F USB stick
  #         "--ignore=private-dev"
  #         # Enable Wayland mode
  #         "--env=NIXOS_OZONE_WL=1"
  #         # Enable system notifications
  #         "--dbus-user.talk=org.freedesktop.Notifications"
  #         # helium-wrapper resolves its own path via readlink/dirname,
  #         # chromium.profile's private-bin doesn't whitelist them by default
  #         "--private-bin=readlink,dirname"
  #       ];
  #     };
  #   };
}
