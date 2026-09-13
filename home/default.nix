{ ... }:
{
  # Home-manager generates an options manpage (`home-configuration.nix(5)`) by
  # default, which evaluates the doc string of every HM option. Options are
  # searched online, not via `man`, so skip it — measurable eval-time win.
  manual.manpages.enable = false;

  xdg.configFile."fontconfig/conf.d/10-hm-fonts.conf".force = true;

  imports = [
    ./agenix.nix
    ./shell
    ./modules
  ];
}
