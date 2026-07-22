{
  home.shellAliases = {
    ":q" = "exit";
    "v" = "nvim";
    "vi" = "nvim";
    "svi" = "sudo -e";
    "ll" = "ls --group-directories-first -lha";
    "l" = "ls --group-directories-first -lh";
    "la" = "ls --group-directories-first -ah";
    "gl" = "git log --pretty=format:\"%h %s\" --graph | head";
    "gla" = "git log --pretty=format:\"%h %s\" --graph";
    "ga" = "git add";
    "gs" = "git status";
    "gc" = "git commit";
    "gr" = "git restore --staged";
    "..." = "cd ../..";
    "ip" = "ip -c=auto";
    "du" = "du -h";
    "ku" = "kubectl";
    "rr" = "echo \"$?\"";
    "sduo" = "sudo";
    "clean" = "sync; nh clean all --keep 3 --optimise";
  };
}
