tmux-config
===========

[tmux-config][0] is a tmux configuration as a TPM package. It is inspired by
[tmux-sensible][1] with some things cleaned up. This plugin is compatible with
[tmux-vim-bindings][2].

## Requirements

- [tmux][3]
- [TPM][4]

## Install

Add plugin to the list of [TPM][4] plugins in `.tmux.conf` (preferably
straight after `tmux-plugins/tpm`):

```
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'ek9/tmux-config'
```

Hit `prefix + I` to fetch the plugin and source it.

## Features

- Enable UTF-8 support
- Address vim mode switching delay problems and workaround bug in OS X
- Force use of correct `$TERM`
- Increase scrollback buffer size
- Increase `tmux` message display time and decrease status refresh times
- Enable mouse focus events and mouse mode (on terminals that support them)
- Enable vi key bindings in `tmux` command prompt and copy mode
- `tmux` grouped session optimizations
- Disable visual bell
- Allow multiple commands under single prefix key within 1000ms
- Minor `tmux` key optimizations*:
  - Make sure `C-b` is unbound if it is not used as a prefix
  - Optimize for fast switching between alternate Windows (if `C-b` is
    prefix then `C-b b` will switch between alternate windows)
  - Bind `prefix r` (e.g. `C-b r`) to quickly source `~/.tmux.conf`
- Minor Display Optimizations:
  - Start window numbering from 1 instead of 0
  - Enable updating of titles
  - Customize statusbar and windows display options
- Other tweaks

## Authors

Copyright (c) 2015-2016 ek9 <dev@ek9.co> (https://ek9.co).

Copyright (c) 2014 Bruno Sutic and [various contributors](https://github.com/tmux-plugins/tmux-sensible/graphs/contributors)
for portions of code from [tmux-sensible][1] project.

## License

Licensed under [MIT License](LICENSE).

[0]: https://github.com/ek9/tmux-config
[1]: https://github.com/tmux-plugins/tmux-sensible
[2]: https://github.com/ek9/tmux-vim-bindings
[3]: https://github.com/tmux/tmux
[4]: https://github.com/tmux-plugins/tpm

