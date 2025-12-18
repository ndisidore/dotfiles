# PATH Configuration
# Loaded before other configs due to 00- prefix

# Local bins
fish_add_path $HOME/.local/bin

# Rust/Cargo
fish_add_path $HOME/.cargo/bin

# Go
set -gx GOPATH $HOME/go
fish_add_path $GOPATH/bin
