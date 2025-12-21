# FZF - Fuzzy Finder
# https://github.com/junegunn/fzf
# Keybindings: Ctrl+R (history), Ctrl+T (files), Alt+C (cd)

if command -v fzf &>/dev/null
    fzf --fish | source
end
