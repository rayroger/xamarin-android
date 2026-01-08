#!/bin/bash

# Verification script for Espresso Tests structure
# This script verifies that all required files are in place for Espresso testing

echo "======================================"
echo "Espresso Tests Structure Verification"
echo "======================================"
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} Found: $1"
        return 0
    else
        echo -e "${RED}✗${NC} Missing: $1"
        return 1
    fi
}

check_dir() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✓${NC} Found directory: $1"
        return 0
    else
        echo -e "${RED}✗${NC} Missing directory: $1"
        return 1
    fi
}

echo "Checking build configuration files..."
check_file "build.gradle"
check_file "settings.gradle"
check_file "gradle.properties"
check_file "local.properties"
echo ""

echo "Checking source directories..."
check_dir "src/main/java/com/companyname/simpleapp"
check_dir "src/androidTest/java/com/companyname/simpleapp"
check_dir "src/main/res/layout"
echo ""

echo "Checking main application files..."
check_file "src/main/AndroidManifest.xml"
check_file "src/main/java/com/companyname/simpleapp/MainActivity.java"
check_file "src/main/res/layout/activity_main.xml"
echo ""

echo "Checking test files..."
check_file "src/androidTest/java/com/companyname/simpleapp/MainActivityTest.java"
echo ""

echo "Analyzing test file..."
if [ -f "src/androidTest/java/com/companyname/simpleapp/MainActivityTest.java" ]; then
    TEST_COUNT=$(grep -c "@Test" src/androidTest/java/com/companyname/simpleapp/MainActivityTest.java)
    echo -e "${GREEN}✓${NC} Found $TEST_COUNT test methods"
    
    echo ""
    echo "Test methods:"
    grep -A 1 "@Test" src/androidTest/java/com/companyname/simpleapp/MainActivityTest.java | grep "public void" | sed 's/.*public void /  - /' | sed 's/().*/()/'
fi
echo ""

echo "Checking for Espresso API usage..."
if [ -f "src/androidTest/java/com/companyname/simpleapp/MainActivityTest.java" ]; then
    ONCLICK_COUNT=$(grep -c "click()" src/androidTest/java/com/companyname/simpleapp/MainActivityTest.java)
    WITHID_COUNT=$(grep -c "withId" src/androidTest/java/com/companyname/simpleapp/MainActivityTest.java)
    WITHTEXT_COUNT=$(grep -c "withText" src/androidTest/java/com/companyname/simpleapp/MainActivityTest.java)
    
    echo -e "${GREEN}✓${NC} click() actions: $ONCLICK_COUNT"
    echo -e "${GREEN}✓${NC} withId() matchers: $WITHID_COUNT"
    echo -e "${GREEN}✓${NC} withText() matchers: $WITHTEXT_COUNT"
fi
echo ""

echo "Verifying UI components in layout..."
if [ -f "src/main/res/layout/activity_main.xml" ]; then
    if grep -q 'android:id="@+id/textView"' src/main/res/layout/activity_main.xml; then
        echo -e "${GREEN}✓${NC} TextView with ID 'textView' found"
    fi
    if grep -q 'android:id="@+id/button"' src/main/res/layout/activity_main.xml; then
        echo -e "${GREEN}✓${NC} Button with ID 'button' found"
    fi
fi
echo ""

echo "======================================"
echo "Verification Complete"
echo "======================================"
echo ""
echo "To build and run the tests, you need:"
echo "  1. Android SDK with API 24+"
echo "  2. Android device or emulator running"
echo "  3. Network connection for dependencies"
echo "  4. Run: ./gradlew connectedAndroidTest"
