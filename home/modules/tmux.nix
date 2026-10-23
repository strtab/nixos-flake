{
  pkgs,
  ...
}:
{
  programs.tmux = {
    enable = true;
    plugins = with pkgs; [
      tmuxPlugins.yank
    ];

    clock24 = true;
    extraConfig = ''
      set -g default-terminal "tmux-256color"
      set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
      set -g detach-on-destroy off
      set -g escape-time 0 
      set -g repeat-time 1000
      set -g history-limit 50000
      set -g set-clipboard on 
      set -g focus-events on
      setw -g mode-keys vi

      set -g mode-style "fg=black,bg=white"

      set -g allow-passthrough on
      set -s extended-keys on
      set -as terminal-features 'xterm*:extkeys'

      set -g status-position top 
      set -g message-style "bg=default,fg=white"
      set -g status-style 'bg=default fg=colour8'

      set -g pane-border-style 'fg=colour239'
      set -g pane-active-border-style 'fg=colour239'

      set -g base-index 1
      set -g pane-base-index 1
      set -g renumber-windows on 

      set-option -g popup-border-lines "none"
      set-option -g popup-style "bg=colour233,fg=#5f5f5f"
      set-option -g popup-border-style "bg=default,fg=#5f5f5f"

      unbind-key -a

      set -g prefix C-space
      bind C-space send-prefix

      bind ? list-keys
      bind n new-window -c "$HOME"
      bind ^D detach
      bind v copy-mode
      bind F1 set-option status off
      bind F2 set-option status on
      bind l refresh-client

      unbind-key -T copy-mode-vi space
      bind-key -T copy-mode-vi v send-keys -X begin-selection

      bind J previous-window
      bind K next-window

      bind ^n new-session
      bind w choose-window
      bind r command-prompt "rename-window %%"
      bind R command-prompt "rename-session %%"

      bind 1 select-window -t 1
      bind 2 select-window -t 2
      bind 3 select-window -t 3
      bind 4 select-window -t 4
      bind 5 select-window -t 5
      bind 6 select-window -t 6
      bind 7 select-window -t 7
      bind 8 select-window -t 8
      bind 9 select-window -t 9
      bind 0 select-window -t 0

      bind -n S-1 join-pane -t :1
      bind -n S-2 join-pane -t :2
      bind -n S-3 join-pane -t :3
      bind -n S-4 join-pane -t :4
      bind -n S-5 join-pane -t :5
      bind -n S-6 join-pane -t :6
      bind -n S-7 join-pane -t :7
      bind -n S-8 join-pane -t :8
      bind -n S-9 join-pane -t :9

      bind ^s split-window -v -c "#{pane_current_path}"
      bind s split-window -v -c "#{pane_current_path}"
      bind ^v split-window -h -c "#{pane_current_path}"

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      bind f resize-pane -Z
      bind x swap-pane -D

      bind : command-prompt
      bind q kill-pane
    '';
  };
}
