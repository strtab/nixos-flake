{ ... }:
{
  programs.obsidian = {
    enable = true;
  };
  home.shellAliases = {
    notes = "nvim ~/.obsidian/notes --cmd 'cd ~/.obsidian/notes'";
    note = "nvim ~/.obsidian/notes --cmd 'cd ~/.obsidian/notes'";
  };
}
