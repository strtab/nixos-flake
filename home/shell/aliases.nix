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
    "clean" = "sync; nh clean all --keep 3 --optimise";
    "nh" = "SOCKS_SERVER=\"\" https_proxy=\"\" http_proxy=\"\" all_proxy=\"\" nh";
    "nix" = "SOCKS_SERVER=\"\" https_proxy=\"\" http_proxy=\"\" all_proxy=\"\" nix";
  };
}
