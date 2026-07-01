{ lib
, config
, pkgs
, ...
}:
{
  services.mbsync.postExec = ''
    ${pkgs.notmuch}/bin/notmuch new
  '';

  home = {
    packages = [ pkgs.notmuch ];
    sessionVariables.NOTMUCH_CONFIG = lib.mkForce "${config.xdg.configHome}/notmuch.conf";

    file."${config.xdg.configHome}/notmuch.conf".enable = false;
    activation.linkNotmuchConfig = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      ln -sf "${config.age.secrets.notmuch.path}" "${config.xdg.configHome}/notmuch.conf"
      chmod 600 "${config.xdg.configHome}/notmuch.conf" 2>/dev/null || true
    '';

    file."${config.home.homeDirectory}/.local/mail/.notmuch/hooks/post-new" = {
      force = true;
      executable = true;
      text = ''
        #!/usr/bin/env bash

        # Reference Maildir folders for tagging
        notmuch tag +gmail "folder:/gmail/"
        notmuch tag +rambler "folder:/rambler/"
        notmuch tag +optsys "folder:/optsys/"

        # Handle sent and spam mail by IMAP folders
        # e.g. if Gmail marks it as spam, tag it as spam
        notmuch tag +sent "folder:/Sent/" and not tag:sent
        notmuch tag +spam "folder:/Spam/" and not tag:spam
        notmuch tag +flagged "folder:/Starred/" and not tag:flagged

        # Send notifications for new emails
        notmuch search --format=json tag:new | jq -r '.[] | [.authors, .subject] | @csv' | while IFS=, read -r from subject; do
          notify-send -a "Notmuch" -c mail "New mail from $from" "$subject"
        done

        # Remove the new tag from all new emails
        notmuch tag -new tag:new
      '';
    };
  };
}
