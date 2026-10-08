#!/bin/bash

# =============================================================================
# Flutter Project Renamer Script
# =============================================================================
# This script renames the Flutter project from the boilerplate name to a new name.
# It handles:
#   - Package name in pubspec.yaml
#   - All Dart import statements
#   - Android application ID and namespace
#   - iOS/macOS bundle identifiers
#   - Linux/Windows application IDs
#   - Display names and labels
#
# Usage:
#   ./scripts/rename_project.sh <new_package_name> <new_org> [new_display_name]
#
# Example:
#   ./scripts/rename_project.sh my_awesome_app com.mycompany "My Awesome App"
# =============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get new values from arguments
NEW_PACKAGE_NAME="${1:-}"
NEW_ORG="${2:-}"
NEW_DISPLAY_NAME="${3:-}"

# Read current values from project files
if [ -f "pubspec.yaml" ]; then
    OLD_PACKAGE_NAME=$(grep "^name:" pubspec.yaml | awk '{print $2}')
else
    echo -e "${RED}Error: pubspec.yaml not found${NC}"
    exit 1
fi

# Try to detect current organization from Android config
if [ -f "android/app/build.gradle.kts" ]; then
    # Extract applicationId in format: "com.example.package_name"
    OLD_ANDROID_PACKAGE=$(grep "applicationId" android/app/build.gradle.kts | head -1 | sed 's/.*"\(.*\)".*/\1/')
    # Extract org by removing the package name suffix
    OLD_ORG=$(echo "$OLD_ANDROID_PACKAGE" | sed "s/\.${OLD_PACKAGE_NAME}$//")
else
    # Fallback to boilerplate default
    OLD_ORG="com.example"
fi

# Try to detect display name from pubspec.yaml
if grep -q "^description:" pubspec.yaml; then
    OLD_DISPLAY_NAME=$(grep "^description:" pubspec.yaml | sed 's/description: //; s/"//g' | head -c 50)
fi

# If display name is still empty, derive it from package name
if [ -z "$OLD_DISPLAY_NAME" ]; then
    OLD_DISPLAY_NAME=$(echo "$OLD_PACKAGE_NAME" | sed 's/_/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')
fi

# Validate arguments
if [ -z "$NEW_PACKAGE_NAME" ] || [ -z "$NEW_ORG" ]; then
    echo -e "${RED}Error: Missing required arguments${NC}"
    echo ""
    echo "Usage: $0 <new_package_name> <new_org> [new_display_name]"
    echo ""
    echo "Arguments:"
    echo "  new_package_name  - The new Dart package name (snake_case, e.g., my_app)"
    echo "  new_org           - The organization identifier (e.g., com.mycompany)"
    echo "  new_display_name  - Optional: The display name for the app"
    echo ""
    echo "Example:"
    echo "  $0 my_awesome_app com.mycompany \"My Awesome App\""
    exit 1
fi

# Validate package name format (must be snake_case)
if ! [[ "$NEW_PACKAGE_NAME" =~ ^[a-z][a-z0-9_]*$ ]]; then
    echo -e "${RED}Error: Package name must be lowercase snake_case (e.g., my_app)${NC}"
    exit 1
fi

# Set display name if not provided
if [ -z "$NEW_DISPLAY_NAME" ]; then
    # Convert snake_case to Title Case
    NEW_DISPLAY_NAME=$(echo "$NEW_PACKAGE_NAME" | sed 's/_/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')
fi

# Calculate derived names
OLD_ANDROID_PACKAGE="${OLD_ORG}.${OLD_PACKAGE_NAME}"
NEW_ANDROID_PACKAGE="${NEW_ORG}.${NEW_PACKAGE_NAME}"

# iOS uses camelCase for bundle identifier
# Using sed -E for macOS compatibility (instead of sed -r)
OLD_IOS_BUNDLE_SUFFIX=$(echo "$OLD_PACKAGE_NAME" | sed -E 's/(^|_)([a-z])/\U\2/g' | sed 's/^./\l&/')
NEW_IOS_BUNDLE_SUFFIX=$(echo "$NEW_PACKAGE_NAME" | sed -E 's/(^|_)([a-z])/\U\2/g' | sed 's/^./\l&/')
OLD_IOS_BUNDLE="${OLD_ORG}.${OLD_IOS_BUNDLE_SUFFIX}"
NEW_IOS_BUNDLE="${NEW_ORG}.${NEW_IOS_BUNDLE_SUFFIX}"

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}                    Flutter Project Renamer                     ${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}Current Configuration:${NC}"
echo "  Package Name:    $OLD_PACKAGE_NAME"
echo "  Organization:    $OLD_ORG"
echo "  Android ID:      $OLD_ANDROID_PACKAGE"
echo "  iOS Bundle:      $OLD_IOS_BUNDLE"
echo ""
echo -e "${GREEN}New Configuration:${NC}"
echo "  Package Name:    $NEW_PACKAGE_NAME"
echo "  Organization:    $NEW_ORG"
echo "  Display Name:    $NEW_DISPLAY_NAME"
echo "  Android ID:      $NEW_ANDROID_PACKAGE"
echo "  iOS Bundle:      $NEW_IOS_BUNDLE"
echo ""

# Confirm before proceeding
read -p "Proceed with renaming? (y/N) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Aborted.${NC}"
    exit 0
fi

echo ""
echo -e "${BLUE}Starting rename process...${NC}"
echo ""

# Function to replace text in files
replace_in_file() {
    local file="$1"
    local old="$2"
    local new="$3"
    
    if [ -f "$file" ]; then
        if grep -q "$old" "$file" 2>/dev/null; then
            if [[ "$OSTYPE" == "darwin"* ]]; then
                sed -i '' "s|$old|$new|g" "$file"
            else
                sed -i "s|$old|$new|g" "$file"
            fi
            echo -e "  ${GREEN}✓${NC} Updated: $file"
        fi
    fi
}

# Function to replace text in all matching files
replace_in_files() {
    local pattern="$1"
    local old="$2"
    local new="$3"
    
    find . -type f -name "$pattern" ! -path "./.git/*" ! -path "./build/*" ! -path "./.dart_tool/*" ! -path "*/Pods/*" | while read -r file; do
        replace_in_file "$file" "$old" "$new"
    done
}

# =============================================================================
# Step 1: Update pubspec.yaml
# =============================================================================
echo -e "${YELLOW}[1/8] Updating pubspec.yaml...${NC}"
replace_in_file "pubspec.yaml" "name: $OLD_PACKAGE_NAME" "name: $NEW_PACKAGE_NAME"
replace_in_file "pubspec.yaml" "$OLD_DISPLAY_NAME" "$NEW_DISPLAY_NAME"

# =============================================================================
# Step 2: Update Dart imports
# =============================================================================
echo -e "${YELLOW}[2/8] Updating Dart imports...${NC}"
replace_in_files "*.dart" "package:$OLD_PACKAGE_NAME/" "package:$NEW_PACKAGE_NAME/"

# =============================================================================
# Step 3: Update Android configuration
# =============================================================================
echo -e "${YELLOW}[3/8] Updating Android configuration...${NC}"

# Update build.gradle.kts
replace_in_file "android/app/build.gradle.kts" "$OLD_ANDROID_PACKAGE" "$NEW_ANDROID_PACKAGE"

# Update MainActivity.kt package declaration
MAIN_ACTIVITY_PATH="android/app/src/main/kotlin/${OLD_ORG//.//}/${OLD_PACKAGE_NAME}/MainActivity.kt"
NEW_MAIN_ACTIVITY_DIR="android/app/src/main/kotlin/${NEW_ORG//.//}/${NEW_PACKAGE_NAME}"

if [ -f "$MAIN_ACTIVITY_PATH" ]; then
    # Create new directory structure
    mkdir -p "$NEW_MAIN_ACTIVITY_DIR"
    
    # Update package declaration and move file
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed "s|package $OLD_ANDROID_PACKAGE|package $NEW_ANDROID_PACKAGE|g" "$MAIN_ACTIVITY_PATH" > "$NEW_MAIN_ACTIVITY_DIR/MainActivity.kt"
    else
        sed "s|package $OLD_ANDROID_PACKAGE|package $NEW_ANDROID_PACKAGE|g" "$MAIN_ACTIVITY_PATH" > "$NEW_MAIN_ACTIVITY_DIR/MainActivity.kt"
    fi
    
    # Remove old directory structure
    rm -rf "android/app/src/main/kotlin/${OLD_ORG//.//}"
    echo -e "  ${GREEN}✓${NC} Moved and updated: MainActivity.kt"
fi

# Update Android manifests
replace_in_files "AndroidManifest.xml" "$OLD_ANDROID_PACKAGE" "$NEW_ANDROID_PACKAGE"
replace_in_files "AndroidManifest.xml" "android:label=\"$OLD_DISPLAY_NAME\"" "android:label=\"$NEW_DISPLAY_NAME\""
# Also handle case where label is just the old package name (fallback)
replace_in_files "AndroidManifest.xml" "android:label=\"$OLD_PACKAGE_NAME\"" "android:label=\"$NEW_DISPLAY_NAME\""

# =============================================================================
# Step 4: Update iOS configuration
# =============================================================================
echo -e "${YELLOW}[4/8] Updating iOS configuration...${NC}"

# Update bundle identifier in project.pbxproj
replace_in_file "ios/Runner.xcodeproj/project.pbxproj" "$OLD_IOS_BUNDLE" "$NEW_IOS_BUNDLE"

# Update Info.plist
replace_in_file "ios/Runner/Info.plist" "<string>$OLD_DISPLAY_NAME</string>" "<string>$NEW_DISPLAY_NAME</string>"
replace_in_file "ios/Runner/Info.plist" "<string>$OLD_PACKAGE_NAME</string>" "<string>$NEW_PACKAGE_NAME</string>"

# =============================================================================
# Step 5: Update macOS configuration
# =============================================================================
echo -e "${YELLOW}[5/8] Updating macOS configuration...${NC}"

# Update AppInfo.xcconfig
replace_in_file "macos/Runner/Configs/AppInfo.xcconfig" "PRODUCT_BUNDLE_IDENTIFIER = $OLD_IOS_BUNDLE" "PRODUCT_BUNDLE_IDENTIFIER = $NEW_IOS_BUNDLE"
replace_in_file "macos/Runner/Configs/AppInfo.xcconfig" "PRODUCT_NAME = $OLD_PACKAGE_NAME" "PRODUCT_NAME = $NEW_PACKAGE_NAME"

# Update bundle identifier in project.pbxproj
replace_in_file "macos/Runner.xcodeproj/project.pbxproj" "$OLD_IOS_BUNDLE" "$NEW_IOS_BUNDLE"

# =============================================================================
# Step 6: Update Linux configuration
# =============================================================================
echo -e "${YELLOW}[6/8] Updating Linux configuration...${NC}"
replace_in_file "linux/CMakeLists.txt" "set(APPLICATION_ID \"$OLD_ANDROID_PACKAGE\")" "set(APPLICATION_ID \"$NEW_ANDROID_PACKAGE\")"
replace_in_file "linux/CMakeLists.txt" "set(BINARY_NAME \"$OLD_PACKAGE_NAME\")" "set(BINARY_NAME \"$NEW_PACKAGE_NAME\")"

# =============================================================================
# Step 7: Update Windows configuration
# =============================================================================
echo -e "${YELLOW}[7/8] Updating Windows configuration...${NC}"
replace_in_file "windows/CMakeLists.txt" "set(BINARY_NAME \"$OLD_PACKAGE_NAME\")" "set(BINARY_NAME \"$NEW_PACKAGE_NAME\")"
replace_in_file "windows/runner/Runner.rc" "$OLD_DISPLAY_NAME" "$NEW_DISPLAY_NAME"

# =============================================================================
# Step 8: Update Web configuration
# =============================================================================
echo -e "${YELLOW}[8/8] Updating Web configuration...${NC}"
replace_in_file "web/index.html" "<title>$OLD_DISPLAY_NAME</title>" "<title>$NEW_DISPLAY_NAME</title>"
replace_in_file "web/manifest.json" "\"name\": \"$OLD_PACKAGE_NAME\"" "\"name\": \"$NEW_PACKAGE_NAME\""
replace_in_file "web/manifest.json" "\"short_name\": \"$OLD_PACKAGE_NAME\"" "\"short_name\": \"$NEW_PACKAGE_NAME\""

# =============================================================================
# Cleanup
# =============================================================================
echo ""
echo -e "${YELLOW}Cleaning up generated files...${NC}"

# Remove build artifacts
rm -rf build/
rm -rf .dart_tool/
rm -rf android/.gradle/
rm -rf ios/Pods/
rm -rf ios/.symlinks/
rm -rf macos/Pods/
rm -rf macos/.symlinks/

# Remove generated Dart files
find . -name "*.g.dart" -type f -delete 2>/dev/null || true
find . -name "*.freezed.dart" -type f -delete 2>/dev/null || true

echo -e "  ${GREEN}✓${NC} Cleaned build artifacts and generated files"

# =============================================================================
# Verification
# =============================================================================
echo ""
echo -e "${YELLOW}Verifying rename...${NC}"

# Check if old package name still exists in critical files
VERIFICATION_PASSED=true

if grep -r "$OLD_PACKAGE_NAME" pubspec.yaml 2>/dev/null | grep -q "name:"; then
    echo -e "  ${RED}✗${NC} pubspec.yaml: Package name not updated correctly"
    VERIFICATION_PASSED=false
else
    echo -e "  ${GREEN}✓${NC} pubspec.yaml: Package name updated"
fi

if grep -r "$OLD_ANDROID_PACKAGE" android/app/build.gradle.kts 2>/dev/null; then
    echo -e "  ${RED}✗${NC} Android: Package ID not updated in build.gradle.kts"
    VERIFICATION_PASSED=false
else
    echo -e "  ${GREEN}✓${NC} Android: Package ID updated"
fi

if grep -r "PRODUCT_BUNDLE_IDENTIFIER = $OLD_IOS_BUNDLE" ios/Runner.xcodeproj/project.pbxproj 2>/dev/null; then
    echo -e "  ${RED}✗${NC} iOS: Bundle ID not updated in project.pbxproj"
    VERIFICATION_PASSED=false
else
    echo -e "  ${GREEN}✓${NC} iOS: Bundle ID updated"
fi

if grep -r "PRODUCT_BUNDLE_IDENTIFIER = $OLD_IOS_BUNDLE" macos/Runner.xcodeproj/project.pbxproj 2>/dev/null; then
    echo -e "  ${RED}✗${NC} macOS: Bundle ID not updated in project.pbxproj"
    VERIFICATION_PASSED=false
else
    echo -e "  ${GREEN}✓${NC} macOS: Bundle ID updated"
fi

# =============================================================================
# Finalize
# =============================================================================
echo ""

if [ "$VERIFICATION_PASSED" = true ]; then
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}                    Rename Complete! 🎉                         ${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
else
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}                Rename Mostly Complete (See Above)              ${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
fi
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Run: flutter pub get"
echo "  2. Run: dart run build_runner build"
echo "  3. For iOS: cd ios && pod install && cd .."
echo "  4. For macOS: cd macos && pod install && cd .."
echo ""
echo -e "${YELLOW}Or simply run:${NC}"
echo "  make prepare"
echo ""
