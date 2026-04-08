#!/usr/bin/env sh

set -u

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)

OS_NAME=$(uname -s 2>/dev/null || echo unknown)

if command -v brew >/dev/null 2>&1; then
    PKG_HINT="brew"
elif command -v apt-get >/dev/null 2>&1; then
    PKG_HINT="apt"
elif command -v dnf >/dev/null 2>&1; then
    PKG_HINT="dnf"
elif command -v pacman >/dev/null 2>&1; then
    PKG_HINT="pacman"
elif command -v zypper >/dev/null 2>&1; then
    PKG_HINT="zypper"
else
    PKG_HINT="unknown"
fi

missing=""

check_bin() {
    if ! command -v "$1" >/dev/null 2>&1; then
        missing="$missing $1"
    fi
}

choose_default_player() {
    case "$OS_NAME" in
        Darwin)
            if [ -x "/Applications/IINA.app/Contents/MacOS/iina-cli" ]; then
                printf "%s" "iina"
            else
                printf "%s" "mpv"
            fi
            ;;
        *)
            printf "%s" "mpv"
            ;;
    esac
}

print_install_hint() {
    dep="$1"
    case "$PKG_HINT:$dep" in
        brew:curl) printf "brew install curl\n" ;;
        brew:grep) printf "brew install grep\n" ;;
        brew:fzf) printf "brew install fzf\n" ;;
        brew:ffmpeg) printf "brew install ffmpeg\n" ;;
        brew:aria2c) printf "brew install aria2\n" ;;
        brew:git) printf "brew install git\n" ;;
        brew:yt-dlp) printf "brew install yt-dlp\n" ;;
        brew:mpv) printf "brew install mpv\n" ;;
        brew:iina) printf "brew install --cask iina\n" ;;
        apt:curl) printf "sudo apt-get install -y curl\n" ;;
        apt:grep) printf "sudo apt-get install -y grep\n" ;;
        apt:fzf) printf "sudo apt-get install -y fzf\n" ;;
        apt:ffmpeg) printf "sudo apt-get install -y ffmpeg\n" ;;
        apt:aria2c) printf "sudo apt-get install -y aria2\n" ;;
        apt:git) printf "sudo apt-get install -y git\n" ;;
        apt:yt-dlp) printf "sudo apt-get install -y yt-dlp\n" ;;
        apt:mpv) printf "sudo apt-get install -y mpv\n" ;;
        dnf:curl) printf "sudo dnf install -y curl\n" ;;
        dnf:grep) printf "sudo dnf install -y grep\n" ;;
        dnf:fzf) printf "sudo dnf install -y fzf\n" ;;
        dnf:ffmpeg) printf "sudo dnf install -y ffmpeg\n" ;;
        dnf:aria2c) printf "sudo dnf install -y aria2\n" ;;
        dnf:git) printf "sudo dnf install -y git\n" ;;
        dnf:yt-dlp) printf "sudo dnf install -y yt-dlp\n" ;;
        dnf:mpv) printf "sudo dnf install -y mpv\n" ;;
        pacman:curl) printf "sudo pacman -S --needed curl\n" ;;
        pacman:grep) printf "sudo pacman -S --needed grep\n" ;;
        pacman:fzf) printf "sudo pacman -S --needed fzf\n" ;;
        pacman:ffmpeg) printf "sudo pacman -S --needed ffmpeg\n" ;;
        pacman:aria2c) printf "sudo pacman -S --needed aria2\n" ;;
        pacman:git) printf "sudo pacman -S --needed git\n" ;;
        pacman:yt-dlp) printf "sudo pacman -S --needed yt-dlp\n" ;;
        pacman:mpv) printf "sudo pacman -S --needed mpv\n" ;;
        zypper:curl) printf "sudo zypper install -y curl\n" ;;
        zypper:grep) printf "sudo zypper install -y grep\n" ;;
        zypper:fzf) printf "sudo zypper install -y fzf\n" ;;
        zypper:ffmpeg) printf "sudo zypper install -y ffmpeg\n" ;;
        zypper:aria2c) printf "sudo zypper install -y aria2\n" ;;
        zypper:git) printf "sudo zypper install -y git\n" ;;
        zypper:yt-dlp) printf "sudo zypper install -y yt-dlp\n" ;;
        zypper:mpv) printf "sudo zypper install -y mpv\n" ;;
        *)
            printf "(no package-manager hint for %s)\n" "$dep"
            ;;
    esac
}

echo "== kanfan-cli dependency check =="
echo "repo: $REPO_DIR"
echo "platform: $OS_NAME"
echo "package_manager_hint: $PKG_HINT"
echo

check_bin curl
check_bin sed
check_bin grep
check_bin fzf
check_bin git
check_bin ffmpeg
check_bin aria2c
check_bin yt-dlp

PLAYER_BIN=$(choose_default_player)
case "$PLAYER_BIN" in
    iina)
        if [ ! -x "/Applications/IINA.app/Contents/MacOS/iina-cli" ] && ! command -v iina >/dev/null 2>&1; then
            missing="$missing iina"
        fi
        ;;
    *)
        check_bin "$PLAYER_BIN"
        ;;
esac

if [ -z "$missing" ]; then
    echo "status: ok"
    echo "All common dependencies were found."
    exit 0
fi

echo "status: missing_dependencies"
echo "missing:$missing"
echo
echo "Suggested install commands:"
for dep in $missing; do
    printf -- "- %s: " "$dep"
    print_install_hint "$dep"
done
echo
echo "Quick start after installation:"
echo "  ./ani-cli --source omofun111 \"进击的巨人\""
echo "  ANI_CLI_PLAYER=debug ./ani-cli --source omofun111 -S 11 -e 1 \"进击的巨人\""
exit 1
