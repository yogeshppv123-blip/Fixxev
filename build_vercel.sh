#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "🚀 Starting Flutter Build for Vercel..."

# Install Flutter if not cached/present
if [ ! -d "flutter" ]; then
    echo "⬇️  Cloning Flutter SDK..."
    git clone https://github.com/flutter/flutter.git -b stable
else
    echo "✅  Flutter SDK already exists."
fi

# Add flutter to path
export PATH="$PATH:`pwd`/flutter/bin"

echo "Running Flutter Doctor..."
flutter doctor -v

echo "⬇️  Getting dependencies..."
flutter pub get

echo "🏗️  Building Web Application..."
flutter build web --release --no-tree-shake-icons

echo "✅  Build Complete! Output in build/web"
