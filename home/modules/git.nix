{ config , lib , pkgs , ... }:
{
  config = lib.mkMerge [
    (lib.mkIf config.var.git.enable {
      home.packages = [ pkgs.gh ];
      programs.git = {
        enable = true;
        settings = {
          fetch.prune = true;
          pull.rebase = true;
          rerere.enabled = true;
          rebase.autoStash = true;
          push.autoSetupRemote = true;
          github.user = config.var.git.username;
          init.defaultBranch = "main";
          merge.conflictStyle = "diff3";
          branch.autoSetupRebase = "always";
          user = {
            email = config.var.git.email;
            name = config.var.fullname;
          };
        };
      };
    })
  ];
}
