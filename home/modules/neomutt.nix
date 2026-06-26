{ pkgs
, lib
, config
, ...
}:
{
  options = {
    email = {
      enable = lib.mkEnableOption "email";
    };
  };

  config = {
    accounts.email = {
      maildirBasePath = "Mail";
      accounts = {
        personal = {
          primary = true;
          realName = "${config.var.fullname}";
          address = "maleshkodaniil@ro.ru";
          passwordeval = "${pkgs.coreutils}/bin/cat ${config.age.secrets."mail/personal-password.age".path}";
          imap = {
            port = 993;
            authentication = "plain";
            host = "imaps://imap.rambler.ru";
          };
          imapnotify.enable = true;
        };
        work = {
          realName = "${config.var.fullname}";
          address = "dmaleshko@optimal.systems";
          passwordeval = "${pkgs.coreutils}/bin/cat ${config.age.secrets."mail/work-password.age".path}";
          imap = {
            port = 993;
            authentication = "plain";
            host = "imaps://imap.masterhost.ru";
          };
          folders = {
            inbox = ".Inbox";
            drafts = ".Drafts";
            sent = ".Sent";
            trash = ".Trash";
          };
          imapnotify.enable = true;
        };
      };
    };

    config = lib.mkIf config.var.email.enable {
      accounts.email.accounts = {
        personal = {
          msmtp.enable = true;
          neomutt = {
            enable = true;
            extraConfig = ''
              color indicator   green default
              color markers     green default
              color search      color0 yellow 
              color status      white default

              set attach_save_dir = ~/Downloads
            '';
          };
        };
      };
      programs.neomutt = {
        enable = true;
        vimKeys = true;
        sort = "reverse-date";
      };
    };
  };
}
