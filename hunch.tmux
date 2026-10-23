#!/usr/bin/env bash
#
# hunch.tmux: send pastes in an editor to the agent registered in hunch.
#
# Loaded by TPM, or from tmux.conf: run-shell /path/to/tmux-hunch/hunch.tmux
# While a pane with role "editor" has focus, the outer terminal's paste
# markers are claimed as user keys 200 and 201, so scripts/hunch-paste can
# forward the paste to the nearest "agent". Other panes get pastes as usual.
#

set -e

CURDIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
PASTE="$CURDIR/scripts/hunch-paste"

# Bindings must also run for keys that arrive fast, as in a paste
tmux set -g assume-paste-time 0
# pane-focus-in fires only with focus events
tmux set -g focus-events on

# Claim the markers when focus moves and when a pane registers in hunch
tmux set-hook -g 'pane-focus-in[200]' "run-shell '$PASTE focus'"
tmux set-hook -g 'after-set-option[200]' "run-shell '$PASTE focus'"

tmux bind -n User200 "run-shell 'TMUX_PANE=#{pane_id} $PASTE start #{client_name}'"
tmux bind -n User201 "send-keys -H 1b 5b 32 30 31 7e"
