# tmux-config

- Enable UTF-8 support
- Address vim mode switching delay problems and workaround bug in OS X
- Force use of correct $TERM
- Increase scrollback buffer size
- Increase `tmux` message display time and decrease status refresh times
- Enable mouse focus events and mouse mode (on terminals that support them)
- Enable vi key bindings in `tmux` command prompt and copy mode
- `tmux` grouped session optimizations
- Disable visual bell
- Allow muliple commands under single prefix key within 500ms
- Minor `tmux` key optimizations*:
  - Make sure `C-b` is unbound if it is not used as a prefix
  - Optimize for fast switching between alternate Windows (if `C-b` is
    prefix then `C-b b` will switch between alternate windows)
  - Bind `prefix r` (e.g. `C-b r`) to quickly source `~/.tmux.conf`
- Minor Display Optimizations:
  - Start window numbering from 1 instead of 0
  - Enable updating of titles
  - Customize statusbar and windows display options

