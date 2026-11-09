{
  config,
  lib,
  pkgs,
  ...
}:
let
  target = "${config.xdg.configHome}/qBittorrent/qBittorrent.conf";

  source = pkgs.writeText "qBittorrent.conf" ''
    [Appearance]
    Style=system

    [BitTorrent]
    MergeTrackersEnabled=true
    Session\AlternativeGlobalDLSpeedLimit=0
    Session\AlternativeGlobalUPSpeedLimit=0
    Session\AnonymousModeEnabled=true
    Session\BTProtocol=Both
    Session\DefaultSavePath=/home/user/Documents/Torrent
    Session\DisableAutoTMMByDefault=true
    Session\DisableAutoTMMTriggers\CategorySavePathChanged=false
    Session\DisableAutoTMMTriggers\DefaultSavePathChanged=false
    Session\GlobalUPSpeedLimit=0
    Session\IgnoreLimitsOnLAN=true
    Session\Interface=
    Session\InterfaceAddress=
    Session\InterfaceName=
    Session\MaxConnections=-1
    Session\MaxConnectionsPerTorrent=-1
    Session\MaxUploads=-1
    Session\MaxUploadsPerTorrent=-1
    Session\Port=43718
    Session\ProxyPeerConnections=false
    Session\QueueingSystemEnabled=false
    Session\ReannounceWhenAddressChanged=true
    Session\SSL\Port=44807
    Session\StartPaused=false
    Session\SubcategoriesEnabled=true
    Session\TempPath=/home/user/Documents/Torrent/temp
    Session\TempPathEnabled=true
    Session\UseAlternativeGlobalSpeedLimit=false
    Session\uTPRateLimited=false

    [Core]
    AutoDeleteAddedTorrentFile=Never

    [GUI]
    DownloadTrackerFavicon=true
    Log\Enabled=false
    MainWindow\FiltersSidebarVisible=false
    MainWindow\FiltersSidebarWidth=0
    RSSWidget\Enabled=false
    StartUpWindowState=Minimized
    UIThemeDialog\Size=@Size(451 348)

    [LegalNotice]
    Accepted=true

    [Preferences]
    Advanced\EnableIconsInMenus=false
    Advanced\RecheckOnCompletion=true
    Advanced\TrayIconStyle=Normal
    Advanced\useSystemIconTheme=true
    General\CloseToTrayNotified=true
    General\ExitConfirm=false
    General\Locale=en
    General\MinimizeToTray=true
    General\MinimizeToTrayNotified=true
    General\NoSplashScreen=true
    General\StatusbarDisplayed=true
    General\StatusbarExternalIPDisplayed=true
    General\ToolbarDisplayed=false
  '';
in
{
  home.activation.qbittorrentConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -e "${target}" ]; then
      run mkdir -p "$(dirname "${target}")"
      # install -m 644 makes the copy writable (store files are 0444)
      run install -m 644 ${source} "${target}"
    fi
  '';
}
