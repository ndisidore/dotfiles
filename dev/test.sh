#!/bin/bash
# Test dotfiles installation in Docker container
set -euo pipefail

GITHUB_USER="${GITHUB_USER:-ndisidore}"
IMAGE_NAME="dotfiles-test"

# Build docker run args, including GITHUB_TOKEN if available
docker_env_args=()
if [[ -n "${GITHUB_TOKEN:-}" ]]; then
    docker_env_args+=(-e "GITHUB_TOKEN=${GITHUB_TOKEN}")
    docker_env_args+=(-e "MISE_GITHUB_TOKEN=${GITHUB_TOKEN}")
fi

build_image() {
    echo "Building Docker image..."
    docker build -t "$IMAGE_NAME" -f dev/Dockerfile .
}

test_container() {
    local use_local="${USE_LOCAL:-false}"
    echo "=== Testing dotfiles ==="

    if [[ "$use_local" == "true" ]]; then
        # Pipe local repo via tar to avoid permission issues with volume mounts
        tar -cf - --exclude='.git' . |
            docker run --rm -i "${docker_env_args[@]}" \
                --entrypoint /bin/bash "$IMAGE_NAME" -c '
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
        docker run --rm "${docker_env_args[@]}" --entrypoint /bin/bash "$IMAGE_NAME" -c '
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
    echo "=== Test complete ==="
}

case "${1:-test}" in
    build)
        build_image
        ;;
    test)
        test_container
        ;;
    all)
        build_image
        test_container
        ;;
    *)
        echo "Usage: $0 {build|test|all}"
        echo ""
        echo "Environment variables:"
        echo "  GITHUB_TOKEN  - GitHub token to avoid rate limiting"
        echo "  USE_LOCAL     - Test local changes instead of cloning (USE_LOCAL=true)"
        echo "  GITHUB_USER   - GitHub user to clone from (default: ndisidore)"
        exit 1
        ;;
esac
