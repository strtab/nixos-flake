{
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.illogical-flake.homeManagerModules.default ];

  wayland.windowManager.hyprland.plugins = [
    inputs.hypr-dynamic-cursors.packages.${pkgs.system}.hypr-dynamic-cursors
  ];

  programs.illogical-impulse = {
    enable = true;
    hyprland = {
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
  };
}
