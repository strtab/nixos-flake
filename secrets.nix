let
  user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOE8FCD8GETUNO78+CXBzue+n2mgQ5lkH/24XX87BuSR";
  users = [ user ];

  moonveil = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGAhJy+OfWazsteSTxKFbA8puZQKnIAu+SMdFA2zUg7i";
  systems = [ moonveil ];
in
{
  # mail
  "secrets/mail/isyncrc.age".publicKeys = systems ++ users;
  "secrets/mail/aerc-accounts.age".publicKeys = systems ++ users;
  "secrets/mail/notmuch.age".publicKeys = systems ++ users;
  "secrets/mail/goimapnotify.age".publicKeys = systems ++ users;

  "secrets/naiveproxy.age".publicKeys = systems ++ users;
  "secrets/git-credentials.age".publicKeys = systems ++ users;
}
