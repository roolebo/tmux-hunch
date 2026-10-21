# tmux-tribe: paste to the agent, stay in the editor

When a pane registered in tribe as `editor` has focus, a paste
from the terminal (Cmd+V in iTerm2, dictation, ...) goes to the nearest pane
registered as `agent`. Typing still goes to the editor, and nothing on screen
moves, even when the agent is in another window.

## Install

Needs `tribe` 0.1.0 and `jq` on PATH. Tested with tmux 3.6. In `~/.tmux.conf`:

    run-shell /path/to/tmux-tribe/tribe.tmux

## How it works

While an editor has focus, the terminal's paste markers (`ESC [200~` and
`ESC [201~`) are claimed as user keys. At the start of a paste, the client
switches to key table `tribe-paste`, which forwards every key to the agent
until the end marker. The agent gets an ordinary bracketed paste followed by
Enter, so the message is sent.

Only a paste in normal or visual mode goes to the agent. Pastes work as
before in insert mode, at a prompt (e.g. Vim's command line), while the
editor doesn't answer (e.g. suspended with Ctrl-Z), without an agent, and
in any other pane. A modeless editor, such as Emacs or VS Code, is always
typing text, so its pastes stay in the editor.

## Side effects

- `assume-paste-time 0`: bindings run even for keys that arrive fast. A key
  bound with `bind -n` can fire on matching pasted text.
- `focus-events on`.
- Uses user keys 200 and 201, hooks `pane-focus-in[200]` and
  `after-set-option[200]`, and key table `tribe-paste`.

## If typing goes to the agent

If the terminal drops a paste's end marker, keys keep going to the agent.
Run `tmux switch-client -T root` from another terminal.
