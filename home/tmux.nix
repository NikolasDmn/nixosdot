{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;

    # Home Manager will write this to ~/.config/tmux/tmux.conf
    extraConfig = ''
      set-option -sa terminal-overrides ",xterm*:Tc"
      set -g mouse on

      unbind C-b
      set -g prefix C-Space
      bind C-Space send-prefix

      # Vim style pane selection
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Start windows and panes at 1, not 0
      set -g base-index 1
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on

      # Use Alt-arrow keys without prefix key to switch panes
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      #unbind H
      #unbind L
      bind -n M-h previous-window
      bind -n M-l next-window

      set -g @plugin 'tmux-plugins/tpm'
      set -g @plugin 'christoomey/vim-tmux-navigator'
      set -g @plugin 'tmux-plugins/tmux-yank'
      set -g @plugin 'egel/tmux-gruvbox'
      set -g @plugin 'tmux-plugins/tmux-resurrect'
      set -g @plugin 'tmux-plugins/tmux-continuum'

      set -g @continuum-restore 'on'
      # set desired theme options...
      set -g @tmux-gruvbox 'dark256' # or 'dark256', 'light', 'light256'

      run '~/.tmux/plugins/tpm/tpm'

      # set vi-mode
      set-window-option -g mode-keys vi
      # keybindings

      bind '"' split-window -v -c "#{pane_current_path}"
      bind | split-window -h -c "#{pane_current_path}"
    '';
  };

  # OPTIONAL but recommended: ensure TPM exists so the `run` line works immediately
  home.activation.installTmuxTpm = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
      ${pkgs.git}/bin/git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    fi
  '';
}
