#!/usr/bin/env bash
# based on https://github.com/tmux-plugins/tmux-sensible

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# used to match output from `tmux list-keys`
KEY_BINDING_REGEX="bind-key[[:space:]]\+\(-r[[:space:]]\+\)\?\(-T prefix[[:space:]]\+\)\?"

is_osx() {
    local platform=$(uname)
    [ "$platform" == "Darwin" ]
}

iterm_terminal() {
    [[ "$TERM_PROGRAM" =~ ^iTerm ]]
}

command_exists() {
    local command="$1"
    type "$command" >/dev/null 2>&1
}

# returns prefix key, e.g. 'C-a'
prefix() {
    tmux show-option -gv prefix
}

# if prefix is 'C-a', this function returns 'a'
prefix_without_ctrl() {
    local prefix="$(prefix)"
    echo "$prefix" | cut -d '-' -f2
}

option_value_not_changed() {
    local option="$1"
    local default_value="$2"
    local option_value=$(tmux show-option -gv "$option")
    [ "$option_value" == "$default_value" ]
}

server_option_value_not_changed() {
    local option="$1"
    local default_value="$2"
    local option_value=$(tmux show-option -sv "$option")
    [ "$option_value" == "$default_value" ]
}

key_binding_not_set() {
    local key="$1"
    if $(tmux list-keys | grep -q "${KEY_BINDING_REGEX}${key}[[:space:]]"); then
        return 1
    else
        return 0
    fi
}

key_binding_not_changed() {
    local key="$1"
    local default_value="$2"
    if $(tmux list-keys | grep -q "${KEY_BINDING_REGEX}${key}[[:space:]]\+${default_value}"); then
        # key still has the default binding
        return 0
    else
        return 1
    fi
}

main() {
    # OPTIONS (based on tmux-sensible)

    # enable utf8
    tmux set-option -g utf8 on

    # enable utf8 in tmux status-left and status-right
    tmux set-option -g status-utf8 on

    # address vim mode switching delay (http://superuser.com/a/252717/65504)
    #if server_option_value_not_changed "escape-time" "500"; then
    tmux set-option -s escape-time 0
    #fi

    # increase scrollback buffer size
    #if option_value_not_changed "history-limit" "2000"; then
    tmux set-option -g history-limit 50000
    #fi

    # tmux messages are displayed for 4 seconds
    tmux set-option -g display-time 4000

    # required (only) on OS X
    if is_osx && command_exists "reattach-to-user-namespace" && option_value_not_changed "default-command" ""; then
        tmux set-option -g default-command "reattach-to-user-namespace -l $SHELL"
    fi

    # upgrade $TERM, tmux 1.9
    if option_value_not_changed "default-terminal" "screen"; then
        tmux set-option -g default-terminal "screen-256color"
    fi
    # upgrade $TERM, tmux 2.0+
    if server_option_value_not_changed "default-terminal" "screen"; then
        tmux set-option -s default-terminal "screen-256color"
    fi

    # use vi key bindings in tmux command prompt
    tmux set-option -g status-keys vi

    # use vi key bindings in copy mode
    tmux set-window-option -g mode-keys vi

    # increase copy buffer limit
    tmux set-option buffer-limit 10

    # enable mouse mode
    tmux set-option -g mode-mouse on
    # enable mouse scrolling (TMUX 2.1)
    # https://github.com/tmux/tmux/issues/145
    #tmux bind-key -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft='#{pane_in_mode}' 'send-keys -M' 'copy-mode -e'"
	tmux bind-key -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'select-pane -t=; copy-mode -e; send-keys -M'"
	tmux bind-key -n WheelDownPane select-pane -t= \; send-keys -M

    # make it scroll half page on wheelup/down
    tmux bind-key -t vi-copy WheelUpPane halfpage-up
    tmux bind-key -t vi-copy WheelDownPane halfpage-down

    # focus events enabled for terminals that support them
    tmux set-option -g focus-events on

    # super useful when using "grouped sessions" and multi-monitor setup
    if ! iterm_terminal; then
        tmux set-window-option -g aggressive-resize on
    fi

    # MINOR KEY BINDING OPTIMIZATIONS (based on tmux-sensible)

    local prefix="$(prefix)"
    local prefix_without_ctrl="$(prefix_without_ctrl)"

    # make sure C-b is unbound if it is not used as prefix
    if [ $prefix != "C-b" ]; then
        # unbind obsolte default binding
        if key_binding_not_changed "C-b" "send-prefix"; then
            tmux unbind-key C-b
        fi

        # pressing `prefix + prefix` sends <prefix> to the shell
        if key_binding_not_set "$prefix"; then
            tmux bind-key "$prefix" send-prefix
        fi
    fi

    # If Ctrl-a is prefix then `Ctrl-a + a` switches between alternate windows.
    # Works for any prefix character.
    if key_binding_not_set "$prefix_without_ctrl"; then
        tmux bind-key "$prefix_without_ctrl" last-window
    fi

    # source `.tmux.conf` file - as suggested in `man tmux`
    if key_binding_not_set "r"; then
        tmux bind-key r run-shell ' \
            tmux source-file ~/.tmux.conf > /dev/null; \
            tmux display-message "Sourced .tmux.conf!"'
    fi

    # GENERAL CUSTOMIZATIONS

    # disable visual bell
    tmux set-option -g   bell-action any
    tmux set-option -g   visual-activity off
    tmux set-option -g   visual-bell off

    # allow multiple commands under single prefix key within specified time (ms)
    tmux set-option -g   repeat-time 1000

    # DISPLAY CUSTOMIZATIONS (edvinasme)
    # start window numbers start from 1 instead of 0
    tmux set-option -g   base-index 1

    # update titles
    tmux set-option -g   set-titles on
    tmux set-option -g   set-titles-string ' #I-#W '

    # Window options
    tmux set-window-option -g clock-mode-style 24
    tmux set-window-option -g monitor-activity on
    tmux set-window-option -g xterm-keys on
    tmux set-window-option -g automatic-rename on

    ### Theme
    ## Statusbar
    # refresh 'status-left' and 'status-right' more often
    tmux set-option -g status-interval 5

     # statusbar customizations
    tmux set-option -g   status-justify left
    tmux set-option -g   status-left-length 100
    tmux set-option -g   status-left '#[fg=green] #(whoami)@#h #[fg=yellow](#S) |'
    tmux set-option -g   status-right '| #[fg=yellow] %Y-%m-%d %H:%M'

    # windows status format
    tmux set-window-option -g window-status-format ' #I-#W '
    tmux set-window-option -g window-status-current-format ' #I-#W '

	set -g window-status-current-bg white
	set -g window-status-current-fg black
	set -g window-status-current-attr bold
}
main
