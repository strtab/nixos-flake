{ inputs, ... }:
{
  imports = [ inputs.aether.homeManagerModules.default ];

  programs.aether = {
    enable = true;
    # qs.overwriting = false;
    # hypridle.enable = false;
    # icons.enable = false;
  };
}
