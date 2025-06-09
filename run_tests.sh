#!/bin/bash

# Check if FVM is installed and use it if available
if command -v fvm &> /dev/null; then
    FLUTTER_CMD="fvm flutter"
    echo "Using FVM for Flutter commands"
else
    FLUTTER_CMD="flutter"
    echo "Using system Flutter installation"
fi

# Function to show usage
show_usage() {
    echo "Usage: $0 [widget|integration|all|list|start]"
    echo "  widget      - Run only widget tests with coverage"
    echo "  integration - Run only integration tests"
    echo "  all         - Run both widget and integration tests (default)"
    echo "  list        - List available devices"
    echo "  start       - Start all available emulators"
    exit 1
}

# Function to list available devices
list_devices() {
    echo "Available devices:"
    $FLUTTER_CMD devices
}

# Start Android emulators
start_android_emulators() {
    echo "Starting Android emulators..."
    EMULATORS=$($FLUTTER_CMD emulators | grep "•" | awk -F '•' '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//')
    
    if [ -z "$EMULATORS" ]; then
        echo "No Android emulators found."
        return
    fi

    for emulator in $EMULATORS; do
        echo "Launching Android emulator: $emulator"
        $FLUTTER_CMD emulators --launch "$emulator"
    done
}

# Start iOS simulators (macOS only)
start_ios_simulators() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "Starting iOS simulators..."
        BOOTED=$(xcrun simctl list devices | grep Booted)
        if [ -z "$BOOTED" ]; then
            DEVICE_ID=$(xcrun simctl list devices available | grep -m 1 'iPhone' | awk -F '[()]' '{print $2}')
            if [ -n "$DEVICE_ID" ]; then
                echo "Booting iOS simulator: $DEVICE_ID"
                xcrun simctl boot "$DEVICE_ID"
            else
                echo "No available iOS simulators found."
            fi
        else
            echo "iOS simulator already booted."
        fi
    fi
}

start_emulators() {
    start_android_emulators
    start_ios_simulators
    echo "Waiting for devices to boot..."
    sleep 10
}

# Run widget tests
run_widget_tests() {
    echo "Running widget tests with coverage..."
    $FLUTTER_CMD test test/widgets/hotel_card_test.dart
}

# Run integration test on a single device
run_integration_tests_on_device() {
    local device_id=$1
    echo "Running integration tests on $device_id..."
    $FLUTTER_CMD drive \
        --driver=integration_test/test_driver/integration_test.dart \
        --target=integration_test/app_test.dart \
        -d "$device_id"
}

# Run integration tests on all devices
run_integration_tests() {
    # Get all connected devices (only mobile devices)
    DEVICES=$($FLUTTER_CMD devices | grep -E "android|ios" | awk -F '•' '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//')
    
    if [ -z "$DEVICES" ]; then
        echo "No mobile devices found. Please start an emulator first."
        echo ""
        echo "You can start available emulators by running:"
        echo "  ./run_tests.sh start"
        echo ""
        echo "Or list available devices with:"
        echo "  ./run_tests.sh list"
        exit 1
    fi

    for device in $DEVICES; do
        echo "----------------------------------------"
        run_integration_tests_on_device "$device"
    done
}

# Main command handler
case "$1" in
    "widget")
        run_widget_tests
        ;;
    "integration")
        run_integration_tests
        ;;
    "all"|"" )
        run_widget_tests
        echo "----------------------------------------"
        run_integration_tests
        ;;
    "list")
        list_devices
        ;;
    "start")
        start_emulators
        ;;
    *)
        show_usage
        ;;
esac
