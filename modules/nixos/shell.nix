{ config, lib, pkgs, ...}: with lib;

let
  cfg = config.blox.profiles;
in {
  options.blox.profiles.zsh.enable = mkEnableOption "ZSH with sane (grml) defaults";
  options.blox.profiles.tmux.enable = mkEnableOption "tmux with sane default configuration";
  config = mkMerge [ {
      environment.systemPackages = with pkgs; [
        atool
        mc
        ranger
        unzip
        zip
      ];
    }
    (mkIf cfg.zsh.enable {
      programs.zsh = {
        enable = true;
        enableGlobalCompInit = false;
      };
      users.defaultUserShell = mkOverride 900 pkgs.zsh;
    })
    (mkIf cfg.tmux.enable {
      programs.tmux = {
        enable = true;
        terminal = "screen-256color";
        extraConfig = ''
          ${optionalString cfg.zsh.enable "set-option -g default-shell ${pkgs.zsh}/bin/zsh"}

          # True color support
          set-option -sa terminal-overrides ",xterm-kitty:Tc,xterm-256color:Tc"

          bind-key    Up    select-pane -U
          bind-key    Down  select-pane -D
          bind-key    Left  select-pane -L
          bind-key    Right select-pane -R

          ########################### Tmux sensible
          # address vim mode switching delay (http://superuser.com/a/252717/65504)
          set -s escape-time 0

          # increase scrollback buffer size
          set -g history-limit 50000

          # tmux messages are displayed for 4 seconds
          set -g display-time 4000

          # upgrade $TERM
          set -g default-terminal "screen-256color"

          # emacs key bindings in tmux command prompt (prefix + :) are better than
          # vi keys, even for vim users
          set -g status-keys emacs

          # focus events enabled for terminals that support them
          set -g focus-events on

          # super useful when using "grouped sessions" and multi-monitor setup
          setw -g aggressive-resize on

          # easier and faster switching between next/prev window
          bind C-p previous-window
          bind C-n next-window

          ########################### Theme related options
          set -g status-interval 10
          set -g status-style bg=black,fg=cyan
          # Left side of status bar
          set -g status-left-style bg=black,fg=green
          set -g status-left-length 40
          set -g status-left "#S #[fg=white]» #[fg=yellow]#I #[fg=cyan]#P"

          # Right side of status bar
          set -g status-right-style bg=black,fg=cyan
          set -g status-right-length 40
          set -g status-right "#H #[fg=white]« #[fg=yellow]%H:%M #[fg=green]%d-%b-%y"

          # Window status
          set -g window-status-format " #I:#W#F "
          set -g window-status-current-format " #I:#W#F "

          # Current window status
          set -g window-status-current-style bg=red,fg=black

          # Window with activity status
          set -g window-status-activity-style bg=yellow,fg=black

          # Window separator
          set -g window-status-separator ""

          # Window status alignment
          set -g status-justify centre

          # Pane border
          set -g pane-border-style bg=default,fg=default

          # Active pane border
          set -g pane-active-border-style bg=default,fg=green

          # Pane number indicator
          set -g display-panes-colour default
          set -g display-panes-active-colour default

          # Clock mode
          set -g clock-mode-colour red
          set -g clock-mode-style 24

          # Message
          set -g message-style bg=default,fg=default

          # Command message
          set -g message-command-style bg=default,fg=default

          # Mode
          set -g mode-style bg=red,fg=default
        '';
      };
    })
  ];
}
