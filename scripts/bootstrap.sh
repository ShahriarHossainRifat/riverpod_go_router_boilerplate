#!/usr/bin/env bash
set -e

echo "🚀 Bootstrapping Flutter project..."

echo "📦 Getting dependencies..."
flutter pub get

echo "🌐 Generating localization files..."
flutter gen-l10n

echo "🔨 Running code generation..."
dart run build_runner build

echo "🔍 Running analyzer..."
flutter analyze

echo "🧪 Running tests..."
flutter test

echo "✅ Bootstrap complete!"
