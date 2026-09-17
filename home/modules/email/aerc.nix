# https://aerc-mail.org/
{ pkgs, config, ... }:
{
  programs.aerc = {
    enable = true;
    package = pkgs.aerc;
  };
  home.packages = with pkgs; [
    html2text
  ];
  home.file."${config.xdg.configHome}/aerc/aerc.conf".text = ''
    [general]
    default-save-path=~/Downloads

    [ui]
    styleset-name=clean
    fuzzy-complete=true

    icon-unencrypted=
    icon-encrypted=✔
    icon-signed=✔
    icon-signed-encrypted=✔
    icon-unknown=✘
    icon-invalid=⚠

    [viewer]
    alternatives=text/html,text/plain
    header-layout=From|To,Cc|Bcc,Date,Subject
    show-headers=false
    always-show-mime=false

    [compose]
    empty-subject-warning=true

    [filters]
    text/plain=colorize
    text/calendar=calendar
    message/delivery-status=colorize
    message/rfc822=colorize
    text/html=! html2text -nobs -links | less

    .headers=colorize

    [hooks]
    mail-received=notify-send "[$AERC_ACCOUNT/$AERC_FOLDER] New mail from $AERC_FROM_NAME" "$AERC_SUBJECT"
  '';
  home.file."${config.xdg.configHome}/aerc/stylesets/clean".text = ''
    *.default=true
    *.normal=true

    border.fg = 232
    *.selected.bold = true
    *.selected.bg = 234
    *.selected.fg = 15

    [viewer]
    *.default=true
    *.normal=true
  '';
  home.file."${config.xdg.configHome}/aerc/map.conf".text = ''
    Inbox=tag:inbox
    Todo=tag:todo and not tag:archived and not tag:deleted
    All=not tag:archived and not tag:deleted and not tag:spam
    Sent=tag:sent
    Spam=tag:spam
    Starred=tag:flagged
  '';
  home.file."${config.xdg.configHome}/aerc/binds.conf".text = ''
    # Binds are of the form <key sequence> = <command to run>
    # To use '=' in a key sequence, substitute it with "Eq": "<Ctrl+Eq>"
    # If you wish to bind #, you can wrap the key sequence in quotes: "#" = quit
    gt = :next-tab<Enter>
    gT = :prev-tab<Enter>
    \[t = :prev-tab<Enter>
    \]t = :next-tab<Enter>
    <C-t> = :term<Enter>
    ? = :help keys<Enter>
    <C-c> = :quit<Enter>
    <C-q> = :quit<Enter>
    <C-w>q = :quit<Enter>
    <C-z> = :suspend<Enter>

    [messages]
    j = :next<Enter>
    <Down> = :next<Enter>
    <C-d> = :next 50%<Enter>
    <C-f> = :next 100%<Enter>
    <PgDn> = :next 100%<Enter>

    k = :prev<Enter>
    <Up> = :prev<Enter>
    <C-u> = :prev 50%<Enter>
    <C-b> = :prev 100%<Enter>
    <PgUp> = :prev 100%<Enter>
    gg = :select 0<Enter>
    G = :select -1<Enter>

    J = :next-folder<Enter>
    <C-Down> = :next-folder<Enter>
    K = :prev-folder<Enter>
    <C-Up> = :prev-folder<Enter>
    H = :collapse-folder<Enter>
    <C-Left> = :collapse-folder<Enter>
    L = :expand-folder<Enter>
    <C-Right> = :expand-folder<Enter>

    v = :mark -t<Enter>
    V = :mark -v<Enter>

    T = :toggle-threads<Enter>
    zc = :fold<Enter>
    zo = :unfold<Enter>
    za = :fold -t<Enter>
    zM = :fold -a<Enter>
    zR = :unfold -a<Enter>
    <tab> = :fold -t<Enter>

    zz = :align center<Enter>
    zt = :align top<Enter>
    zb = :align bottom<Enter>

    <Space> = :view<Enter>
    <Enter> = :view<Enter>
    d = :choose -o y 'Really delete this message' delete-message<Enter>
    D = :delete<Enter>
    a = :archive flat<Enter>
    A = :unmark -a<Enter>:mark -T<Enter>:archive flat<Enter>

    C = :compose<Enter>
    m = :compose<Enter>

    b = :bounce<space>

    rr = :reply -a<Enter>
    rq = :reply -aq<Enter>
    Rr = :reply<Enter>
    Rq = :reply -q<Enter>

    c = :cf<space>
    $ = :term<space>
    ! = :term<space>
    | = :pipe<space>

    / = :search<space>
    \ = :filter<space>
    n = :next-result<Enter>
    N = :prev-result<Enter>
    <Esc> = :clear<Enter>

    s = :split<Enter>
    S = :vsplit<Enter>

    pl = :patch list<Enter>
    pa = :patch apply <Tab>
    pd = :patch drop <Tab>
    pb = :patch rebase<Enter>
    pt = :patch term<Enter>
    ps = :patch switch <Tab>

    [messages:folder=Drafts]
    <Enter> = :recall<Enter>

    [view]
    / = :toggle-key-passthrough<Enter>/
    q = :close<Enter>
    <C-w>q = :close<Enter>
    O = :open<Enter>
    o = :open<Enter>
    S = :save<Enter>
    | = :pipe<space>
    D = :delete<Enter>
    A = :archive flat<Enter>

    <C-y> = :copy-link <space>
    <C-l> = :open-link <space>

    f = :forward<Enter>
    rr = :reply -a<Enter>
    rq = :reply -aq<Enter>
    Rr = :reply<Enter>
    Rq = :reply -q<Enter>

    H = :toggle-headers<Enter>
    <C-k> = :prev-part<Enter>
    <C-j> = :next-part<Enter>
    <C-Up> = :prev-part<Enter>
    <C-Down> = :next-part<Enter>
    J = :next<Enter>
    <C-Right> = :next<Enter>
    K = :prev<Enter>
    <C-Left> = :prev<Enter>

    [view::passthrough]
    $noinherit = true
    $ex = <C-x>
    <Esc> = :toggle-key-passthrough<Enter>

    [compose]
    # Keybindings used when the embedded terminal is not selected in the compose
    # view
    $noinherit = true
    $ex = <C-x>
    $complete = <C-o>
    <C-k> = :prev-field<Enter>
    <C-Up> = :prev-field<Enter>
    <C-j> = :next-field<Enter>
    <C-Down> = :next-field<Enter>
    <A-p> = :switch-account -p<Enter>
    <C-Left> = :switch-account -p<Enter>
    <A-n> = :switch-account -n<Enter>
    <C-Right> = :switch-account -n<Enter>
    <tab> = :next-field<Enter>
    <backtab> = :prev-field<Enter>
    <C-p> = :prev-tab<Enter>
    <C-PgUp> = :prev-tab<Enter>
    <C-n> = :next-tab<Enter>
    <C-PgDn> = :next-tab<Enter>

    [compose::editor]
    # Keybindings used when the embedded terminal is selected in the compose view
    $noinherit = true
    $ex = <C-x>
    <C-k> = :prev-field<Enter>
    <C-Up> = :prev-field<Enter>
    <C-j> = :next-field<Enter>
    <C-Down> = :next-field<Enter>
    <C-p> = :prev-tab<Enter>
    <C-PgUp> = :prev-tab<Enter>
    <C-n> = :next-tab<Enter>
    <C-PgDn> = :next-tab<Enter>

    [compose::review]
    # Keybindings used when reviewing a message to be sent
    # Inline comments are used as descriptions on the review screen
    y = :send<Enter> # Send
    n = :abort<Enter> # Abort (discard message, no confirmation)
    s = :sign<Enter> # Toggle signing
    x = :encrypt<Enter> # Toggle encryption to all recipients
    v = :preview<Enter> # Preview message
    p = :postpone<Enter> # Postpone
    q = :choose -o d discard abort -o p postpone postpone<Enter> # Abort or postpone
    e = :edit<Enter> # Edit (body and headers)
    a = :attach<space> # Add attachment
    d = :detach<space> # Remove attachment

    [terminal]
    $noinherit = true
    $ex = <C-x>

    <C-p> = :prev-tab<Enter>
    <C-n> = :next-tab<Enter>
    <C-PgUp> = :prev-tab<Enter>
    <C-PgDn> = :next-tab<Enter>
  '';

  home.file."${config.xdg.configHome}/aerc/accounts.conf".enable = false;
  home.activation.linkAercConfig = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "${config.xdg.configHome}/aerc"
    ln -sf "${config.age.secrets.aerc-accounts.path}" "${config.xdg.configHome}/aerc/accounts.conf"
    chmod 600 "${config.xdg.configHome}/aerc/accounts.conf" 2>/dev/null || true
  '';
}
