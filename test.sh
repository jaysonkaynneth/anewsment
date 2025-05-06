#!/bin/bash

# For running tests (showing coverage and formatting)
echo "🧪 Running all tests..."
flutter test

# Run specific tests
if [ "$1" == "services" ]; then
  echo "🔍 Running service tests specifically..."
  flutter test test/services/
fi

if [ "$1" == "utils" ]; then
  echo "🔍 Running utility tests specifically..."
  flutter test test/utils/
fi

if [ "$1" == "widgets" ]; then
  echo "🔍 Running widget tests specifically..."
  flutter test test/widget_test.dart
fi

echo "✅ Test run completed!" 