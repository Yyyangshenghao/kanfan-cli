#!/usr/bin/env sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
OS_NAME=$(uname -s 2>/dev/null || echo unknown)

INSTALL_DIR="${KANFAN_INSTALL_DIR:-}"
INSTALL_DEPS=1
COPY_SCRIPT=1

usage() {
    cat <<'EOF'
Usage: ./scripts/install.sh [options]

Options:
  --no-deps           Do not install dependencies
  --no-copy           Do not copy ani-cli into a PATH directory
  --install-dir PATH  Copy target directory for ani-cli
  -h, --help          Show help
EOF
}

while [ $# -gt 0 ]; do
    case "$1" in
        --no-deps) INSTALL_DEPS=0 ;;
        --no-copy) COPY_SCRIPT=0 ;;
        --install-dir)
            [ $# -lt 2 ] && { echo "missing argument for --install-dir" >&2; exit 1; }
            INSTALL_DIR="$2"
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "unknown option: $1" >&2
            usage >&2
            exit 1
            ;;
    esac
    shift
done

need_cmd() {
    command -v "$1" >/dev/null 2>&1
}

run_cmd() {
    echo "+ $*"
    "$@"
}

install_with_brew() {
    run_cmd brew install curl grep aria2 ffmpeg git fzf yt-dlp
    if [ "$OS_NAME" = "Darwin" ]; then
        run_cmd brew install --cask iina
    else
        run_cmd brew install mpv
    fi
}

install_with_apt() {
    run_cmd sudo apt-get update
    run_cmd sudo apt-get install -y curl grep fzf ffmpeg aria2 git yt-dlp mpv
}

install_with_dnf() {
    run_cmd sudo dnf install -y curl grep fzf ffmpeg aria2 git yt-dlp mpv
}

install_with_pacman() {
    run_cmd sudo pacman -S --needed curl grep fzf ffmpeg aria2 git yt-dlp mpv
}

install_with_zypper() {
    run_cmd sudo zypper install -y curl grep fzf ffmpeg aria2 git yt-dlp mpv
}

detect_install_dir() {
    if [ -n "$INSTALL_DIR" ]; then
        printf "%s" "$INSTALL_DIR"
        return
    fi

    if [ "$OS_NAME" = "Darwin" ] && need_cmd brew; then
        printf "%s/bin" "$(brew --prefix)"
        return
    fi

    if [ -d "$HOME/.local/bin" ]; then
        printf "%s" "$HOME/.local/bin"
        return
    fi

    printf "%s" "/usr/local/bin"
}

echo "== kanfan-cli installer =="
echo "repo: $REPO_DIR"
echo "platform: $OS_NAME"
echo

if [ "$INSTALL_DEPS" = "1" ]; then
    if need_cmd brew; then
        install_with_brew
    elif need_cmd apt-get; then
        install_with_apt
    elif need_cmd dnf; then
        install_with_dnf
    elif need_cmd pacman; then
        install_with_pacman
    elif need_cmd zypper; then
        install_with_zypper
    else
        echo "No supported package manager found."
        echo "Run ./scripts/check-deps.sh for manual install hints."
    fi
fi

if [ "$COPY_SCRIPT" = "1" ]; then
    TARGET_DIR=$(detect_install_dir)
    if [ "$TARGET_DIR" = "/usr/local/bin" ] && [ ! -w "$TARGET_DIR" ]; then
        echo "+ sudo mkdir -p $TARGET_DIR"
        sudo mkdir -p "$TARGET_DIR"
        echo "+ sudo cp $REPO_DIR/ani-cli $TARGET_DIR/ani-cli"
        sudo cp "$REPO_DIR/ani-cli" "$TARGET_DIR/ani-cli"
        echo "+ sudo chmod +x $TARGET_DIR/ani-cli"
        sudo chmod +x "$TARGET_DIR/ani-cli"
    else
        mkdir -p "$TARGET_DIR"
        run_cmd cp "$REPO_DIR/ani-cli" "$TARGET_DIR/ani-cli"
        run_cmd chmod +x "$TARGET_DIR/ani-cli"
    fi
    echo
    echo "Installed launcher to: $TARGET_DIR/ani-cli"
fi

echo
echo "Recommended verification commands:"
echo "  ani-cli --source omofun111 \"进击的巨人\""
echo "  ANI_CLI_PLAYER=debug ani-cli --source omofun111 -S 11 -e 1 \"进击的巨人\""
echo
echo "If something still fails, run:"
echo "  ./scripts/check-deps.sh"
