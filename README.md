# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/) and [mise](https://mise.jdx.dev/).

## Features

- **Declarative tool management** - Dev tools defined in `~/.config/mise/config.toml`
- **Modular shell config** - Fish shell with conf.d structure for clean organization
- **Multi-machine support** - Template-based config for work/personal machines
- **Automated setup** - Bootstrap scripts install tools on `chezmoi apply`

## Quick Start

### One-liner (new machine)

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply ndisidore
```

### Manual Setup

```bash
# 1. Install chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)"

# 2. Initialize from repo
chezmoi init ndisidore

# 3. Preview changes
chezmoi diff

# 4. Apply
chezmoi apply
```

## Structure

```
~/.local/share/chezmoi/
├── .chezmoi.toml.tmpl              # Machine-specific config (name, email, type)
├── .chezmoiignore                  # Conditional file ignores
├── run_onchange_install-mise-tools.sh.tmpl   # Auto-install mise tools
├── run_onchange_install-uv-tools.sh.tmpl     # Auto-install Python tools
├── dot_gitconfig.tmpl              # Git config (templated)
└── dot_config/
    ├── mise/config.toml            # Dev tools (runtimes, CLIs)
    ├── uv/tools.txt                # Python tools (copier, posting, etc.)
    ├── private_fish/               # Fish shell
    │   ├── config.fish             # Main config
    │   └── conf.d/                 # Modular configs
    │       ├── 00-path.fish        # PATH setup
    │       ├── 10-mise.fish        # Mise activation
    │       ├── 20-starship.fish    # Prompt
    │       └── 30-aliases.fish     # Aliases
    ├── starship.toml               # Prompt config
    ├── zellij/config.kdl           # Terminal multiplexer
    ├── helix/config.toml           # Editor
    ├── alacritty/                  # Terminal emulator
    └── git/ignore                  # Global gitignore
```

## Core Tools

| Tool | Purpose |
|------|---------|
| [chezmoi](https://www.chezmoi.io/) | Dotfile management |
| [mise](https://mise.jdx.dev/) | Dev tool version manager |
| [fish](https://fishshell.com/) | Shell |
| [starship](https://starship.rs/) | Prompt |
| [zellij](https://zellij.dev/) | Terminal multiplexer |
| [helix](https://helix-editor.com/) | Editor |
| [uv](https://docs.astral.sh/uv/) | Python package manager |

## Package Management Strategy

| Type | Tool | Examples |
|------|------|----------|
| Dev tools | mise | go, node, ripgrep, gh, dagger |
| Python tools | uv tool | copier, posting, jiratui |
| System packages | flatpak > apt | - |

## Adding Tools

### Mise tools
Edit `~/.config/mise/config.toml`:
```toml
[tools]
newtool = "latest"
```

### Python tools
Edit `~/.config/uv/tools.txt`:
```
newtool
```

Then run `chezmoi apply`.

## Multi-Machine Config

On first `chezmoi init`, you'll be prompted for:
- **name** - Your full name (for git)
- **email** - Your email (for git)
- **machine_type** - `work` or `personal`

These values are stored in `~/.config/chezmoi/chezmoi.toml` and used in templates.

## License

MIT
