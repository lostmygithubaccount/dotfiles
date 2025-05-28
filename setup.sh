#!/bin/bash
# Setup script for dotfiles - runs sync.py in bootstrap mode

set -euo pipefail

# Change to the directory containing this script
cd "$(dirname "$0")"

echo "🚀 Setting up dotfiles..."

# Run sync in init mode (non-interactive bootstrap)
./bin/sync.py --init

echo "✅ Dotfiles setup complete!"