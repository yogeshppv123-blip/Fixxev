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
# Pass API_URL from environment if available
if [ -n "$API_URL" ]; then
    echo "Using API_URL: $API_URL"
    flutter build web --release --dart-define=API_URL="$API_URL" --no-tree-shake-icons
else
    echo "Using default API_URL (http://127.0.0.1:5001/api)"
    flutter build web --release --no-tree-shake-icons
fi

echo "✅  Build Complete! Output in build/web"
