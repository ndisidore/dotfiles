# Fish Shell Configuration
# Modular configs are loaded from conf.d/

## General Settings
set -g fish_greeting
set -gx EDITOR hx

## Interactive shell setup
if status is-interactive
    # Zellij auto-start
    eval (zellij setup --generate-auto-start fish | string collect)
end
