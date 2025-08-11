#!/bin/bash

# Flutter Performance Testing Script for Zapchat
# This script helps you run different performance tests and profiling

set -e

echo "🚀 Flutter Performance Testing Suite"
echo "====================================="

# Check if fvm is available
if command -v fvm &> /dev/null; then
    FLUTTER_CMD="fvm flutter"
    echo "✅ Using FVM for Flutter commands"
else
    FLUTTER_CMD="flutter"
    echo "⚠️  FVM not found, using system Flutter"
fi

# Function to run profile mode
run_profile() {
    echo ""
    echo "📱 Running in Profile Mode..."
    echo "This provides production-like performance with debugging tools enabled"
    $FLUTTER_CMD run --profile -d android
}

# Function to build profile APK
build_profile_apk() {
    echo ""
    echo "📦 Building Profile APK..."
    $FLUTTER_CMD build apk --profile
    echo "✅ Profile APK built: build/app/outputs/flutter-apk/app-profile.apk"
}

# Function to run with performance overlay
run_with_overlay() {
    echo ""
    echo "📊 Running with Performance Overlay..."
    echo "This shows frame timing graphs on screen"
    $FLUTTER_CMD run --profile --enable-software-rendering
}

# Function to analyze code for performance issues
analyze_code() {
    echo ""
    echo "🔍 Running Flutter Analyze..."
    $FLUTTER_CMD analyze --no-fatal-warnings
    echo "✅ Code analysis complete"
}

# Function to run specific performance tests
run_tests() {
    echo ""
    echo "🧪 Running Widget Tests..."
    $FLUTTER_CMD test
}

# Function to show Flutter DevTools info
show_devtools_info() {
    echo ""
    echo "🛠️  Flutter DevTools Instructions:"
    echo "=================================="
    echo "1. Start your app in profile mode: $FLUTTER_CMD run --profile"
    echo "2. Open DevTools in browser: http://localhost:9100"
    echo "3. Or run: $FLUTTER_CMD pub global run devtools"
    echo ""
    echo "📈 Key DevTools Features:"
    echo "- Performance Tab: Frame timeline and CPU profiling"
    echo "- Memory Tab: Memory usage and leak detection"
    echo "- Inspector Tab: Widget tree and rebuild analysis"
    echo "- Network Tab: HTTP requests monitoring"
}

# Function to check for common performance issues
check_performance_issues() {
    echo ""
    echo "🔍 Checking for Common Performance Issues..."
    echo "==========================================="
    
    # Check for ListView without keys
    echo "📝 Checking for ListView items without keys..."
    if grep -r "ListView.builder" lib/ | grep -v "key:" > /dev/null; then
        echo "⚠️  Found ListView.builder without keys - may cause performance issues"
    else
        echo "✅ ListView items have keys"
    fi
    
    # Check for function creation in build methods
    echo "📝 Checking for function creation in build methods..."
    if grep -r "onPressed: ()" lib/ > /dev/null; then
        echo "⚠️  Found anonymous functions in build methods - may cause rebuilds"
    fi
    
    # Check for setState calls
    echo "📝 Checking setState usage..."
    setState_count=$(grep -r "setState(" lib/ | wc -l)
    echo "📊 Found $setState_count setState calls"
    
    echo "✅ Performance check complete"
}

# Main menu
show_menu() {
    echo ""
    echo "Choose a performance testing option:"
    echo "1) Run in Profile Mode"
    echo "2) Build Profile APK"
    echo "3) Run with Performance Overlay"
    echo "4) Analyze Code"
    echo "5) Run Widget Tests"
    echo "6) Show DevTools Info"
    echo "7) Check Performance Issues"
    echo "8) Exit"
    echo ""
    read -p "Enter your choice (1-8): " choice
    
    case $choice in
        1) run_profile ;;
        2) build_profile_apk ;;
        3) run_with_overlay ;;
        4) analyze_code ;;
        5) run_tests ;;
        6) show_devtools_info ;;
        7) check_performance_issues ;;
        8) echo "👋 Goodbye!"; exit 0 ;;
        *) echo "❌ Invalid choice"; show_menu ;;
    esac
}

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: pubspec.yaml not found. Please run this script from your Flutter project root."
    exit 1
fi

# Show the menu
show_menu