{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    nerd-fonts.symbols-only
  ];
  programs.kitty = {
    enable = true;
    font = {
      name = "family='Inter'";
      package = pkgs.inter;
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

    foreground              #cecdc3
    background              #000000
    selection_foreground    #FFFCF0
    selection_background    #403E3C
    url_color               #CE5D97

    color0  #100F0F
    color8  #6F6E69
    color1  #D14D41
    color9  #D14D41
    color2  #879A39
    color10 #879A39
    color3  #D0A215
    color11 #D0A215
    color4  #859fba
    color12 #859fba
    color5  #CE5D97
    color13 #CE5D97
    color6  #458588
    color14 #458588
    color7  #F2F0E5
    color15 #FFFCF0
    color16 #DA702C
    color17 #DA702C
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
