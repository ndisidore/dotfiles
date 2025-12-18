# Shell Aliases

# Modern CLI replacements (if available via mise)
if command -v eza &> /dev/null
    alias ls='eza'
    alias ll='eza -l'
    alias la='eza -la'
    alias lt='eza --tree'
end

if command -v bat &> /dev/null
    alias cat='bat --paging=never'
end

# Cursor IDE helper
function cursor
    nohup ~/Applications/Cursor.AppImage $argv --no-sandbox >/dev/null 2>&1 &
end
