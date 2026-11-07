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
    extraConfig = ''
      include theme.conf
    '';
  };
  home.file."${config.xdg.configHome}/kitty/theme.conf".text = ''
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
    color4  #606060
    color12 #606060
    color5  #CE5D97
    color13 #CE5D97
    color6  #ADBD60
    color14 #ADBD60
    color7  #F2F0E5
    color15 #FFFCF0
    color16 #DA702C
    color17 #DA702C
  '';
}
