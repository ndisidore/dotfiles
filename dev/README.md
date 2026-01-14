# Dev - Docker Testing Environment

Test dotfiles installation in an isolated container without affecting your real home directory.

## Quick Start

```bash
# Build image and run test
./dev/test.sh all

# Or separately:
./dev/test.sh build
./dev/test.sh test
```

## Environment Variables

### GITHUB_TOKEN

Pass a GitHub token to avoid rate limiting when installing mise tools:

```bash
GITHUB_TOKEN=$(gh auth token) ./dev/test.sh test
```

### USE_LOCAL

Test local uncommitted changes instead of cloning from GitHub:

```bash
USE_LOCAL=true ./dev/test.sh test
```

### GITHUB_USER

Change the GitHub user to clone from (default: `ndisidore`):

```bash
GITHUB_USER=myuser ./dev/test.sh test
```

## Manual Testing

```bash
# Build
docker build -t dotfiles-test -f dev/Dockerfile .

# Run interactive shell
docker run --rm -it dotfiles-test

# Inside container: install and apply dotfiles
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply ndisidore
```

## What's Included

The container (Debian trixie-slim) comes with:
- Fish shell (default)
- Git, curl, bash
- mise (pre-installed)
- Non-root user with sudo access
- Locale support (en_US.UTF-8)

## Verification

After applying dotfiles, verify everything works:

```fish
mise list          # Check tools installed
starship --version # Check prompt
chezmoi managed    # Check managed files
uv tool list       # Check Python tools
```
