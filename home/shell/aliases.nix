{
  home.shellAliases = {
    ":q" = "exit";
    "v" = "nvim";
    "vi" = "nvim";
    "svi" = "sudo -e";
    "ll" = "ls --group-directories-first -lha";
    "l" = "ls --group-directories-first -lh";
    "la" = "ls --group-directories-first -ah";
    "hl" = "rg --passthru";
    "ip" = "ip -c=auto";
    "ku" = "kubectl";
    "ec" = "echo \"$?\"";
    "sduo" = "sudo";
    "clean" = "sudo sync; sudo journalctl --rotate --vacuum-size=10M; nh clean all --keep 3 --optimise";
  };
}
