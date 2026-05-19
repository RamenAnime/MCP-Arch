#!/usr/bin/env bash
# One-command entry: clone/update repo and run the main installer
set -euo pipefail

REPO_URL="${KYOTO_REPO_URL:-https://github.com/RamenAnime/MCP-Arch.git}"
INSTALL_DIR="${KYOTO_INSTALL_DIR:-$HOME/kyoto-learn-os}"

echo "Kyoto Learn OS - easy installer"
echo "Full desktop: i3 UI + Japanese lessons + shell immersion"
echo ""
echo "Pick your guide:"
echo "  Need Arch first?     docs/INSTALL-FRESH-ARCH.md"
echo "  Arch already there?  docs/INSTALL-EXISTING-ARCH.md"
echo ""
echo "Repository: $REPO_URL"
echo ""

if [ -d "$INSTALL_DIR/.git" ]; then
  echo "Updating existing copy in $INSTALL_DIR ..."
  git -C "$INSTALL_DIR" pull --ff-only
else
  echo "Cloning into $INSTALL_DIR ..."
  git clone "$REPO_URL" "$INSTALL_DIR"
fi

cd "$INSTALL_DIR"
chmod +x mcp-arch.sh easy-install.sh bin/* install/*.sh config/polybar/launch.sh config/i3/lock.sh 2>/dev/null || true

echo ""
echo "Starting installer (sudo required)..."
echo "  Arch not installed yet? Choose 1 in the installer (shows the Arch guide)."
echo "  Arch ready? Choose 2 (PC) or 3 (VM) for the full Kyoto Learn desktop."
echo ""
exec sudo ./mcp-arch.sh
