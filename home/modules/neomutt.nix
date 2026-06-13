{ ... }:
{
  accounts.email.accounts = {
    personal = {
      msmtp.enable = true;
      neomutt = {
        enable = true;
        extraConfig = ''
          color attachment  color13 default
          color indicator   color15 default
          color markers     color6  default
          color search      color0  color3 
          color status      white   default

          set attach_save_dir = ~/Downloads
          set folder = ~/.mail
        '';
      };
    };
  };
  programs.neomutt = {
    enalbe = true;
    vimKeys = true;
    sort = "reverse-date";
  };
}
