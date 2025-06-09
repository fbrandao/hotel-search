# 📘 QA Environment Setup Guide for `hotel-search` Flutter App

This guide walks you through setting up a full QA environment for the `hotel-search` Flutter app.  
Each section includes validation steps to ensure your tools are installed and configured correctly.

---

## 🧰 Required Tools Overview

| Tool               | Purpose                                  | Required Version         |
|--------------------|------------------------------------------|---------------------------|
| Flutter SDK        | Core development framework               | 3.24.0                   |
| Java JDK           | Needed by Android SDK                    | 17 or newer              |
| Android Studio     | Emulator, SDK manager                    | Latest                    |
| Git                | Clone project                            | ≥ 2.30                    |
| Node.js *(optional)* | Needed for Maestro CLI tests            | Latest                    |
| Xcode *(macOS only)* | iOS simulator and builds               | Latest                    |

> ⚠️ If any required tool is not available in your environment, install it before continuing.

---

## 1️⃣ Install Flutter SDK

[Install Flutter](https://flutter.dev/docs/get-started/install)

### ✅ Setup Flutter

1. Download Flutter SDK from https://docs.flutter.dev/get-started/install
2. Extract to a location (e.g., `C:\src\flutter` on Windows)
3. Add Flutter to PATH:
   - Windows: Add `C:\src\flutter\bin` to System Environment Variables
   - macOS/Linux: Add `export PATH="$PATH:$HOME/flutter/bin"` to `~/.bashrc` or `~/.zshrc`
4. Restart terminal

### ✅ Validate

```bash
flutter --version
dart --version
```

---

## 2️⃣ Install Java JDK

Java is required for Android builds and emulator tools.

### ✅ Install

Choose one of these OpenJDK distributions:

1. **Eclipse Temurin** (recommended)  
   https://adoptium.net/temurin/releases/

2. **Oracle OpenJDK**  
   https://jdk.java.net/

Download **OpenJDK 17 or newer**, install it, and set your JAVA_HOME appropriately.

### ✅ Validate

```bash
java -version
```

✅ Expected output:
```
openjdk version "17.x" or newer
```

❌ **If "command not found"**:
- **Windows**: Add the Java `bin` directory to your system `Path`
- **macOS/Linux**: Add `export PATH="/path/to/java/bin:$PATH"` to `~/.zshrc` or `~/.bashrc`

---

### ⚠️ Optional Java 21 Compatibility Fix

If you use **Java 21 or newer**, you may see errors like:

```
Execution failed for task ':path_provider_android:compileDebugJavaWithJavac'
Execution failed for JdkImageTransform
```

This is due to AGP 8.1.0 not being compatible with Java 21.

#### ✅ Option A: Upgrade Gradle & AGP

- In `android/settings.gradle`:
  ```groovy
  id "com.android.application" version "8.3.0" apply false
  ```
- In `android/gradle/wrapper/gradle-wrapper.properties`:
  ```properties
  distributionUrl=https\://services.gradle.org/distributions/gradle-8.5-all.zip
  ```

Then run:
```bash
flutter clean
flutter pub get
flutter run
```

#### 🟡 Option B: Downgrade to Java 17

If you prefer not to modify the project, install **Java 17** instead and switch your environment.

```bash
java -version  # should show 17.x
fvm flutter run
```

✅ This resolves the issue without modifying build files.

---

## 3️⃣ (Optional) Install FVM for Flutter Version Management

```bash
dart pub global activate fvm
```

Add this to PATH:
- Windows: `C:\Users\<you>\AppData\Local\Pub\Cache\bin`
- macOS/Linux: `export PATH="$PATH:$HOME/.pub-cache/bin"`

### ✅ Validate

```bash
fvm --version
```

---

## 4️⃣ Install Android Studio

Android Studio is the official IDE for Android development and provides essential tools for Flutter development on Android.

### Why Android Studio?

- **Android SDK Manager**: Manages Android SDK versions and build tools
- **Android Emulator**: Test your app on virtual devices
- **Build Tools**: Compile and package your Android app
- **Debugging Tools**: Debug native Android code
- **Device Manager**: Create and manage virtual devices
- **Gradle Integration**: Build system for Android apps

### ✅ Install

1. Download from [developer.android.com/studio](https://developer.android.com/studio)
2. Run the installer and follow the setup wizard
3. During first launch, install these components via SDK Manager:
   - **Android SDK Platform-Tools**: Essential command-line tools
   - **Android SDK Build-Tools**: Required for building apps
   - **Android SDK Command-line Tools**: Additional development tools
   - **Android Emulator**: Virtual device for testing
   - **Android SDK Platform**: At least one platform (API 31+ recommended)
   - **Intel x86 Emulator Accelerator (HAXM)**: For better emulator performance

### ✅ Configure

1. Open Android Studio
2. Go to **Tools → SDK Manager**
3. In **SDK Platforms** tab:
   - Check "Show Package Details"
   - Select at least one Android version (API 31+)
   - Check "Android SDK Platform" and "Sources"
4. In **SDK Tools** tab:
   - Check "Android SDK Build-Tools"
   - Check "Android SDK Command-line Tools"
   - Check "Android Emulator"
   - Check "Android SDK Platform-Tools"

### ✅ Validate

Run these commands to verify your Android setup:

```bash
# Check ADB (Android Debug Bridge)
adb --version

# Check Android SDK location
echo $ANDROID_HOME  # macOS/Linux
echo %ANDROID_HOME% # Windows

# List connected devices and emulators
adb devices

# Check Android SDK components
sdkmanager --list | grep "installed"

# Verify Flutter can find Android SDK
flutter doctor --android-licenses
flutter doctor -v
```

✅ Expected outputs:

1. ADB version:
```
Android Debug Bridge version 1.0.x
Version x.x.x-xxxxxx
Installed as /path/to/adb
```

2. Android SDK location:
```
/path/to/Android/Sdk  # macOS/Linux
C:\Users\<you>\AppData\Local\Android\Sdk  # Windows
```

3. Connected devices:
```
List of devices attached
emulator-5554    device  # If emulator is running
```

4. Flutter doctor should show:
```
[✓] Android toolchain - develop for Android devices
    • Android SDK at /path/to/Android/Sdk
    • Platform android-xx, build-tools xx.x.x
    • Java binary at: /path/to/java
    • Java version OpenJDK Runtime Environment
    • All Android licenses accepted
```

### ⚠️ Common Issues

1. **Emulator is slow**:
   - Enable virtualization in BIOS
   - Install HAXM (Intel) or use ARM images
   - Increase RAM/CPU in AVD settings

2. **SDK not found**:
   - Set `ANDROID_HOME` environment variable
   - Windows: `C:\Users\<you>\AppData\Local\Android\Sdk`
   - macOS/Linux: `$HOME/Library/Android/sdk`

3. **Build tools missing**:
   - Open SDK Manager
   - Install missing build tools version

4. **Android licenses not accepted**:
   ```bash
   flutter doctor --android-licenses
   # Accept all licenses when prompted
   ```

5. **Emulator not starting**:
   ```bash
   # Check if virtualization is enabled
   systeminfo | findstr /i "Virtualization"  # Windows
   sysctl -a | grep machdep.cpu.features | grep VMX  # macOS
   grep -E --color 'vmx|svm' /proc/cpuinfo  # Linux
   ```

---

## 5️⃣ Clone the Project

```bash
git clone https://github.com/Buenro/hotel-search.git
cd hotel-search
```

---

## 6️⃣ Set Up Flutter Version

This project uses Flutter `3.24.0`.

```bash
fvm install 3.24.0
fvm use 3.24.0
```

### ✅ Validate

```bash
fvm flutter --version
```

---

## 7️⃣ Install Project Dependencies

```bash
fvm flutter pub get
```

✅ All packages should resolve with no errors

---

## 8️⃣ Run Code Generators

```bash
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

✅ Should complete successfully

---

## 9️⃣ Configure SERPAPI

The app uses SERPAPI for hotel search functionality. You'll need to set up your API key.

### 1. Get SERPAPI Key

1. Go to [serpapi.com](https://serpapi.com)
2. Sign up for a free account
3. Get your API key from the dashboard

### 2. Configure Environment Variables

1. Create a `.env` file in the project root:
   ```bash
   touch .env
   ```

2. Add your SERPAPI key:
   ```
   SERPAPI_KEY=your_api_key_here
   ```

3. Create a `.env.example` file for reference:
   ```
   SERPAPI_KEY=your_serpapi_key_here
   ```

### 3. Validate Setup

1. Check if the API key is loaded:
   ```bash
   flutter run
   # Should not show any API key errors
   ```

2. Test the search functionality:
   - Open the app
   - Enter a location
   - Verify that hotel results appear

### ⚠️ Common Issues

1. **API Key Not Found**
   - Ensure `.env` file exists in project root
   - Check if key is properly formatted
   - Verify the key is valid in SERPAPI dashboard

2. **Rate Limiting**
   - Free tier has limited requests
   - Check usage in SERPAPI dashboard
   - Consider upgrading if needed

3. **Search Not Working**
   - Verify internet connection
   - Check API key permissions
   - Look for error messages in console

---

## 🔟 Launch Emulator or Simulator

Create and launch via:
```bash
flutter emulators
flutter emulators --launch <emulator-id>
```

Or manually via Android Studio → Device Manager.

### ✅ Validate

```bash
flutter devices
```

✅ At least one emulator or device should be listed.

---

## 🔟 Run the App

```bash
fvm flutter run
```

✅ App should launch in the emulator.

---

## 1️⃣1️⃣ Run Tests

### ✅ Widget Tests

```bash
fvm flutter test
```

✅ All tests in the `test/` folder should pass.

---

## 🧪 Integration Tests

```bash
fvm flutter drive --target=integration_test/app_test.dart
```

---

## 🛠 Optional: Patrol or Maestro

```bash
# Patrol
fvm flutter pub add --dev patrol
fvm flutter test integration_test/

# Maestro
npm install -g @mobile-dev/maestro
maestro test flow.yaml
```

---

## 🧪 Running Tests

### Using the Test Script

The project includes a `run_tests.sh` script that automates test execution across multiple devices. The script supports:

```bash
./run_tests.sh [command]

Commands:
  widget      - Run only widget tests with coverage
  integration - Run only integration tests
  all         - Run both widget and integration tests (default)
  list        - List available devices
  start       - Start all available emulators
```

#### Features

1. **Device Management**
   - Lists all connected devices (`./run_tests.sh list`)
   - Starts Android emulators automatically (`./run_tests.sh start`)
   - Supports iOS simulators on macOS
   - Waits for devices to boot properly

2. **Test Execution**
   - Runs widget tests with coverage
   - Runs integration tests on all connected mobile devices
   - Can run both test types in sequence
   - Shows clear progress and results for each device

3. **Error Handling**
   - Checks for device availability
   - Validates emulator status
   - Shows clear error messages
   - Handles test failures gracefully

#### Example Usage

1. **List Available Devices**
   ```bash
   ./run_tests.sh list
   # Shows all connected devices and emulators
   ```

2. **Start Emulators**
   ```bash
   ./run_tests.sh start
   # Starts all available Android emulators
   # On macOS, also starts iOS simulator if available
   ```

3. **Run All Tests**
   ```bash
   ./run_tests.sh all
   # Runs widget tests first
   # Then runs integration tests on all connected devices
   ```

4. **Run Specific Tests**
   ```bash
   # Run only widget tests
   ./run_tests.sh widget

   # Run only integration tests
   ./run_tests.sh integration
   ```

#### Requirements

- Flutter SDK installed and in PATH
- Android Studio with emulators set up
- On macOS: Xcode for iOS simulator support
- Connected devices or emulators for integration tests

#### Troubleshooting

1. **No Devices Found**
   ```bash
   # Start emulators first
   ./run_tests.sh start
   
   # Then run tests
   ./run_tests.sh integration
   ```

2. **Emulator Not Starting**
   - Check Android Studio's Device Manager
   - Verify virtualization is enabled in BIOS
   - Ensure HAXM is installed (for Intel processors)

3. **Test Failures**
   - Check device logs for errors
   - Verify app is properly installed
   - Check network connectivity for API tests

---

## ✅ Final QA Environment Checklist

| Step       | Command                    | ✅ Expect           |
|------------|-----------------------------|---------------------|
| Flutter    | `flutter --version`         | 3.24.0              |
| Java       | `java -version`             | JDK 17.x or newer   |
| Dart       | `dart --version`            | 3.x                 |
| FVM        | `fvm --version`             | Installed (optional)|
| Devices    | `flutter devices`           | Lists emulator      |
| Run App    | `flutter run`               | App launches        |
| Run Tests  | `flutter test`              | Tests pass          |
