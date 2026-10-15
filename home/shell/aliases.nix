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
    "noproxy" = "SOCKS_SERVER=\"\" https_proxy=\"\" http_proxy=\"\" all_proxy=\"\"";
    "clean" = "sudo sync; sudo journalctl --rotate --vacuum-size=10M; nh clean all --keep 3 --optimise";
  };
}
