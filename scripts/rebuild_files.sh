#!/bin/bash

# Generate code
echo "👉 generating code"

flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter pub get