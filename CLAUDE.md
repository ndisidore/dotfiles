# CLAUDE.md

This file provides context for Claude Code when working in this repository.

## Repository Overview

This is a personal dotfiles repository for Linux, managed with:
- **chezmoi** - Dotfile management and templating
- **mise** - Dev tool version management (primary "package manager")
- **uv** - Python tool management

## Directory Structure

```
.
├── .chezmoi.toml.tmpl          # Config template (prompts for name, email, machine_type)
├── .chezmoiignore              # Conditional ignores based on machine_type
├── run_onchange_*.sh.tmpl      # Bootstrap scripts (run on config changes)
├── dot_gitconfig.tmpl          # Templated git config
└── dot_config/                 # Maps to ~/.config/
    ├── mise/config.toml        # Dev tools definition
    ├── uv/tools.txt            # Python tools list
    ├── private_fish/           # Fish shell (private permissions)
    └── ...                     # Other app configs
```

## Chezmoi Naming Conventions

| Prefix | Effect |
|--------|--------|
| `dot_` | Renames to `.` (dot_config → .config) |
| `private_` | Sets restrictive permissions (700/600) |
| `.tmpl` suffix | Processes as Go template |
| `run_` prefix | Executable script |
| `run_onchange_` | Runs when content hash changes |

## Key Files

- **`dot_config/mise/config.toml`** - All dev tools. Add tools here, not manually.
- **`dot_config/uv/tools.txt`** - Python CLI tools installed via `uv tool`.
- **`dot_config/private_fish/conf.d/`** - Modular fish configs (loaded alphabetically).
- **`dot_gitconfig.tmpl`** - Uses `{{ .name }}` and `{{ .email }}` from chezmoi data.

## Development Workflow

### Testing changes
```bash
chezmoi diff          # Preview what will change
chezmoi apply -n      # Dry run
chezmoi apply         # Apply changes
```

### Adding a new tool to mise
1. Edit `dot_config/mise/config.toml`
2. Run `chezmoi apply` (triggers `run_onchange_install-mise-tools.sh`)

### Adding a Python tool
1. Edit `dot_config/uv/tools.txt`
2. Run `chezmoi apply` (triggers `run_onchange_install-uv-tools.sh`)

### Adding a new config file
```bash
chezmoi add ~/.config/newapp/config.toml
```

## Shell Environment

- **Shell**: Fish 3.x
- **Prompt**: Starship
- **Multiplexer**: Zellij
- **Editor**: Helix (`hx`)

Fish configs are modular in `conf.d/`:
- `00-path.fish` - PATH setup (cargo, local bins)
- `10-mise.fish` - Mise activation
- `20-starship.fish` - Prompt initialization
- `30-aliases.fish` - Shell aliases (eza, bat, etc.)

## Template Variables

Available in `.tmpl` files via chezmoi:
- `{{ .name }}` - User's full name
- `{{ .email }}` - User's email
- `{{ .machine_type }}` - "work" or "personal"
- `{{ .chezmoi.os }}` - Operating system
- `{{ .chezmoi.hostname }}` - Machine hostname

## Constraints

- **Don't commit secrets** - Use chezmoi's encryption or external secret managers
- **Test before pushing** - Run `chezmoi diff` to verify changes
- **Prefer mise** - Add dev tools to mise config, not manual installs
- **Prefer uv** - Add Python CLI tools to uv/tools.txt, not pip

## Common Tasks

### Check what chezmoi manages
```bash
chezmoi managed
```

### See chezmoi data/variables
```bash
chezmoi data
```

### Re-run bootstrap scripts
```bash
chezmoi apply --force
```

### Edit a managed file
```bash
chezmoi edit ~/.config/starship.toml
```
