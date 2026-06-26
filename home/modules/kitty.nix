{ pkgs, config, ... }:
{
  programs.kitty = {
    enable = true;
    font = {
      name = "family='Google Sans Code' variable_name=GoogleSansCode wght=440 MONO=1";
      package = pkgs.googlesans-code;
      size = 16;
    };
    shellIntegration.enableZshIntegration = true;
    enableGitIntegration = true;
    settings = {
      enable_audio_bell = false;
      confirm_os_window_close = 0;
      window_padding_width = 20;
      cursor_shape = "block";
      cursor_trail = 0;
      cursor_stop_blinking_after = 0;
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
    background                      #000000
    selection_foreground            #c8c093
    selection_background            #2d4f67

    cursor                          #929292

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

    foreground                      #545464
    background                      #f2ecbc
    selection_foreground            #43436c
    selection_background            #c9cbd1

    cursor                          #43436c
    cursor_text_color               #f2ecbc

    url_color                       #73a7bc

    active_tab_foreground           #716e61
    active_tab_background           #e5ddb0
    inactive_tab_foreground         #8a8980
    inactive_tab_background         #d5cea3

    color0  #1f1f28
    color8  #8a8980

    color1  #c84053
    color9  #d7474b

    color2  #6f894e
    color10 #6e915f

    color3  #77713f
    color11 #836f4a

    color4  #4d699b
    color12 #6693bf

    color5  #b35b79
    color13 #624c83

    color6  #597b75
    color14 #5e857a

    color7  #545464
    color15 #43436c

    color16 #cc6d00
    color17 #e82424
  '';
}
