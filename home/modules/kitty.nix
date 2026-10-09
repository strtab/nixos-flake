{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    nerd-fonts.symbols-only
    nerd-fonts.jetbrains-mono
  ];
  programs.kitty = {
    enable = true;
    font = {
      # name = "family='Google Sans Code' variable_name=GoogleSansCode wght=440 MONO=1";
      # package = pkgs.googlesans-code;
      name = "family='GeistMono Nerd Font'";
      package = pkgs.nerd-fonts.geist-mono;
    };
    shellIntegration.enableZshIntegration = true;
    shellIntegration.mode = "no-cursor";
    enableGitIntegration = true;
    settings = {
      enable_audio_bell = true;
      remember_window_size = false;
      confirm_os_window_close = 0;
      window_padding_width = 5;
      cursor_shape = "block";
      cursor_trail = 0;
      cursor_stop_blinking_after = 0;
      symbol_map = "U+23 JetBraindMonoNL Nerd Font";
      allow_hyperlinks = true;
      underline_hyperlinks = "always";
      show_hyprlink_target_on_hover = true;
    };
    keybindings = {
      "ctrl+plus" = "change_font_size all +1";
      "ctrl+equal" = "change_font_size all +1";
      "ctrl+kp_add" = "change_font_size all +1";
      "ctrl+minus" = "change_font_size all -1";
      "ctrl+underscore" = "change_font_size all -1";
      "ctrl+kp_subtract" = "change_font_size all -1";
      "ctrl+0" = "change_font_size all 0";
      "ctrl+kp_0" = "change_font_size all 0";
    };
  };
  home.file."${config.xdg.configHome}/kitty/dark-theme.auto.conf".text = ''
    # vim:ft=kitty

    foreground                      #bcb7aa
    background                      #050505

    url_color                       #72a7bc

    active_tab_foreground           #c8c093
    active_tab_background           #131313
    inactive_tab_foreground         #727169
    inactive_tab_background         #131313

    color0  #16161d
    color8  #727169

    color1  #c34043
    color9  #e82424

    color2  #76946a
    color10 #98bb6c

    color3  #c0a36e
    color11 #e6c384

    color4  #859fac
    color12 #859fac

    color5  #957fb8
    color13 #938aa9

    color6  #6a9589
    color14 #7aa89f

    color7  #c8c093
    color15 #dcd7ba

    color16 #ffa066
    color17 #ff5d62
  '';
  home.file."${config.xdg.configHome}/kitty/light-theme.auto.conf".text = ''
    # vim:ft=kitty

    background #fcfcfc
    foreground #111111

    cursor  #e8dffd
    selection_background #e8dffd
    selection_foreground #ffffff

    color0  #100F0F
    color8  #6F6E69
    color1  #D14D41
    color9  #AF3029
    color2  #879A39
    color10 #66800B
    color3  #D0A215
    color11 #AD8301
    color4  #4385BE
    color12 #205EA6
    color5  #CE5D97
    color13 #A02F6F
    color6  #3AA99F
    color14 #24837B
    color7  #FFFCF0
    color15 #F2F0E5
  '';
}
