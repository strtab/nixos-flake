{ ... }:
{
  # Home-manager generates an options manpage (`home-configuration.nix(5)`) by
  # default, which evaluates the doc string of every HM option. Options are
  # searched online, not via `man`, so skip it — measurable eval-time win.
  manual.manpages.enable = false;

  imports = [
    ./agenix.nix
    ./shell
    ./modules
  ];
}
