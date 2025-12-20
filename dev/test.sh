#!/bin/bash
# Test dotfiles installation in Docker containers
set -euo pipefail

GITHUB_USER="${GITHUB_USER:-ndisidore}"

# Build docker run args, including GITHUB_TOKEN if available
docker_env_args=()
if [[ -n "${GITHUB_TOKEN:-}" ]]; then
    docker_env_args+=(-e "GITHUB_TOKEN=${GITHUB_TOKEN}")
    docker_env_args+=(-e "MISE_GITHUB_TOKEN=${GITHUB_TOKEN}")
fi

test_container() {
    local distro="$1"
    local use_local="${USE_LOCAL:-false}"
    echo "=== Testing on ${distro} ==="

    if [[ "$use_local" == "true" ]]; then
        # Pipe local repo via tar to avoid permission issues with volume mounts
        tar -cf - --exclude='.git' . |
            docker run --rm -i "${docker_env_args[@]}" \
                --entrypoint /bin/bash "dotfiles-${distro}" -c '
            set -e
            export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

            # Pre-create chezmoi config to bypass interactive prompts
            mkdir -p ~/.config/chezmoi
            cat > ~/.config/chezmoi/chezmoi.toml << EOF
[data]
    name = "Test User"
    email = "test@example.com"
    machine_type = "personal"
EOF

            # Extract local repo to chezmoi source
            mkdir -p ~/.local/share/chezmoi
            tar -xf - -C ~/.local/share/chezmoi

            # Install chezmoi
            sh -c "$(curl -fsLS get.chezmoi.io)"

            # Apply dotfiles
            chezmoi apply --force

            echo ""
            echo "=== Installed configs ==="
            ls ~/.config/

            echo ""
            echo "=== Testing mise ==="
            mise --version

            echo ""
            echo "=== Chezmoi managed files ==="
            chezmoi managed | head -20

            echo ""
            echo "=== uv tools ==="
            mise exec -- uv tool list

            echo ""
            echo "✓ Test passed!"
        '
    else
        docker run --rm "${docker_env_args[@]}" --entrypoint /bin/bash "dotfiles-${distro}" -c '
            set -e
            export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

            # Pre-create chezmoi config to bypass interactive prompts
            mkdir -p ~/.config/chezmoi
            cat > ~/.config/chezmoi/chezmoi.toml << EOF
[data]
    name = "Test User"
    email = "test@example.com"
    machine_type = "personal"
EOF

            # Install chezmoi and clone repo (without apply)
            sh -c "$(curl -fsLS get.chezmoi.io)"
            chezmoi init '"${GITHUB_USER}"'

            # Apply dotfiles
            chezmoi apply --force

            echo ""
            echo "=== Installed configs ==="
            ls ~/.config/

            echo ""
            echo "=== Testing mise ==="
            mise --version

            echo ""
            echo "=== Chezmoi managed files ==="
            chezmoi managed | head -20

            echo ""
            echo "=== uv tools ==="
            mise exec -- uv tool list

            echo ""
            echo "✓ Test passed!"
        '
    fi
    echo "=== ${distro} complete ==="
}

# Build images if needed
build_images() {
    echo "Building Docker images..."
    docker build -t dotfiles-ubuntu -f dev/Dockerfile.ubuntu .
    docker build -t dotfiles-alpine -f dev/Dockerfile.alpine .
}

case "${1:-test}" in
    build)
        build_images
        ;;
    ubuntu)
        test_container "ubuntu"
        ;;
    alpine)
        test_container "alpine"
        ;;
    all | test)
        test_container "alpine"
        test_container "ubuntu"
        ;;
    *)
        echo "Usage: $0 {build|ubuntu|alpine|all}"
        exit 1
        ;;
esac
