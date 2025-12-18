# Dev - Docker Testing Environment

Test dotfiles installation in isolated containers without affecting your real home directory.

## Quick Start

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

## Testing Workflow

1. Build the container
2. Run interactive shell
3. Install chezmoi and apply dotfiles
4. Verify everything works:
   ```fish
   mise list          # Check tools installed
   starship --version # Check prompt
   chezmoi managed    # Check managed files
   ```

## One-liner Test

```bash
# Ubuntu
docker build -t dotfiles-ubuntu -f dev/Dockerfile.ubuntu . && \
docker run --rm -it dotfiles-ubuntu -c 'sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply ndisidore && fish'

# Alpine
docker build -t dotfiles-alpine -f dev/Dockerfile.alpine . && \
docker run --rm -it dotfiles-alpine -c 'sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply ndisidore && fish'
```
