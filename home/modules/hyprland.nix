{
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.aether.homeManagerModules.default ];

  wayland.windowManager.hyprland.plugins = [
    inputs.hyblock.packages.${pkgs.stdenv.hostPlatform.system}.hyblock
  ];

  programs.aether = {
    enable = true;
    # qs.overwriting = false;
    # hypridle.enable = false;
    hyprland = {
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
  };
}
