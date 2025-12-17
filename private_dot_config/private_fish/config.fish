## General
set -g fish_greeting
set -gx EDITOR hx

## Local bins
fish_add_path $HOME/.local/bin
### Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

## Language Setup
### Rust
fish_add_path $HOME/.cargo/bin
### Go
set -gx GOPATH $HOME/go
fish_add_path $GOPATH/bin
fish_add_path /usr/local/go/bin

starship init fish | source

function cursor
    # Start the Cursor AppImage in the background, suppressing output
    nohup ~/Applications/Cursor.AppImage $argv --no-sandbox >/dev/null 2>&1 &
end

if status is-interactive
    # Zellij setup & aliases
    eval (zellij setup --generate-auto-start fish | string collect)
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
/home/ndisidore/.local/bin/mise activate fish | source
