{ config, ... }:
let
  obsidianPath = "${config.home.homeDirectory}/.local/share/obsidian";
in
{
  programs.obsidian = {
    enable = true;
    cli.enable = true;
  };
  home.shellAliases = {
    notes = "nvim --cmd 'cd ${obsidianPath}/notes'";
    note = "nvim --cmd 'cd ${obsidianPath}/notes'";
  };
}
