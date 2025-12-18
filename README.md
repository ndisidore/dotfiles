# dotfiles

<div align="center">

[![CI](https://github.com/ndisidore/dotfiles/actions/workflows/ci.yaml/badge.svg)](https://github.com/ndisidore/dotfiles/actions/workflows/ci.yaml)
[![Renovate](https://img.shields.io/badge/renovate-enabled-brightgreen?logo=renovatebot)](https://github.com/ndisidore/dotfiles/issues)

[![twpayne/chezmoi](https://img.shields.io/github/v/tag/twpayne/chezmoi?color=4078c0&display_name=release&label=chezmoi&logo=git&logoColor=4078c0&sort=semver)](https://github.com/twpayne/chezmoi)
[![jdx/mise](https://img.shields.io/github/v/tag/jdx/mise?color=00acc1&display_name=release&label=mise&logo=gnometerminal&logoColor=00acc1&sort=semver)](https://github.com/jdx/mise)
[![fish-shell/fish-shell](https://img.shields.io/github/v/tag/fish-shell/fish-shell?color=4AAE46&display_name=release&label=fish&logo=gnubash&logoColor=4AAE46&sort=semver)](https://github.com/fish-shell/fish-shell)
[![starship/starship](https://img.shields.io/github/v/tag/starship/starship?color=DD0B78&display_name=release&label=starship&logo=starship&logoColor=DD0B78&sort=semver)](https://github.com/starship/starship)
[![zellij-org/zellij](https://img.shields.io/github/v/tag/zellij-org/zellij?color=BF9B30&display_name=release&label=zellij&sort=semver)](https://github.com/zellij-org/zellij)
[![helix-editor/helix](https://img.shields.io/github/v/tag/helix-editor/helix?color=A07BDE&display_name=release&label=helix&sort=semver)](https://github.com/helix-editor/helix)

</div>

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

## Development

Docker containers are provided for testing dotfiles installation on fresh systems.

### Quick Test

```bash
# Build and test on Alpine
./dev/test.sh build
./dev/test.sh alpine

# Or Ubuntu
./dev/test.sh ubuntu

# Test both
./dev/test.sh all
```

### Interactive Testing

```bash
# Build images
docker build -t dotfiles-ubuntu -f dev/Dockerfile.ubuntu .
docker build -t dotfiles-alpine -f dev/Dockerfile.alpine .

# Run interactive shell
docker run --rm -it dotfiles-ubuntu
docker run --rm -it dotfiles-alpine

# Inside container: install and apply dotfiles
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply ndisidore
```

### What's Included

Both containers come pre-installed with:
- Fish shell (default)
- Git, curl, bash
- mise
- Non-root user with sudo access
- Build dependencies for compiling runtimes

See `dev/README.md` for more details.

## License

MIT
