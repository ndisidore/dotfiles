# Dev - Docker Testing Environment

Test dotfiles installation in isolated containers without affecting your real home directory.

## Quick Start

```bash
# Build images
./dev/test.sh build

# Test on Ubuntu (recommended - uses prebuilt binaries)
./dev/test.sh ubuntu

# Test on Alpine (slower - compiles Node/Python from source)
./dev/test.sh alpine

# Test both
./dev/test.sh all
```

## Environment Variables

### GITHUB_TOKEN

Pass a GitHub token to avoid rate limiting when installing mise tools:

```bash
# Using gh CLI
GITHUB_TOKEN=$(gh auth token) ./dev/test.sh ubuntu

# Or export directly
export GITHUB_TOKEN="ghp_xxxx"
./dev/test.sh ubuntu
```

### USE_LOCAL

Test local uncommitted changes instead of cloning from GitHub:

```bash
USE_LOCAL=true ./dev/test.sh ubuntu
```

This is useful for testing changes before pushing.

### GITHUB_USER

Change the GitHub user to clone from (default: `ndisidore`):

```bash
GITHUB_USER=myuser ./dev/test.sh ubuntu
```

## Manual Testing

### Ubuntu

```bash
# Build
docker build -t dotfiles-ubuntu -f dev/Dockerfile.ubuntu .

# Run interactive shell
docker run --rm -it dotfiles-ubuntu

# Inside container: install and apply dotfiles
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply ndisidore
```

### Alpine

```bash
# Build
docker build -t dotfiles-alpine -f dev/Dockerfile.alpine .

# Run interactive shell
docker run --rm -it dotfiles-alpine

# Inside container: install and apply dotfiles
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply ndisidore
```

## What's Included

Both containers come with:
- Fish shell (default)
- Git, curl, bash
- mise (pre-installed)
- Non-root user with sudo access
- Font support (for Nerd Fonts)

**Ubuntu additionally has:**
- Prebuilt binaries for most mise tools (fast installs)

**Alpine additionally has:**
- Build dependencies for compiling from source
- musl libc (some tools need gcompat)

## Ubuntu vs Alpine

| Aspect | Ubuntu | Alpine |
|--------|--------|--------|
| Node.js install | ~5 seconds | ~10+ minutes |
| Python install | ~5 seconds | ~5+ minutes |
| Image size | Larger | Smaller |
| Recommended for | Full testing | Minimal/CI |

**Recommendation:** Use Ubuntu for development testing. Alpine requires compiling Node/Python from source which is slow.

## Verification

After applying dotfiles, verify everything works:

```fish
mise list          # Check tools installed
starship --version # Check prompt
chezmoi managed    # Check managed files
uv tool list       # Check Python tools
```
