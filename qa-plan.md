# ✅ Comprehensive QA Test Strategy & Scenarios for Hotel Search App

## 🎯 Objective
Ensure quality and usability of the Hotel Search Flutter application through prioritized manual and automated testing. This document supports the QA lifecycle from test planning to test execution.

---

## 🧪 Test Case Format

| Field            | Description                                          |
|------------------|------------------------------------------------------|
| **ID**           | Unique identifier (e.g., `TS-01`)                    |
| **Feature**      | App feature under test                               |
| **Title**        | Brief description of the test case                   |
| **Priority**     | High / Medium / Low                                  |
| **Preconditions**| App state, environment, or test data required        |
| **Test Steps**   | Step-by-step actions to perform                      |
| **Expected Result** | What the app should do                            |

---

## 🔝 Priority 1 – Core Features

### TS-01 – Search Functionality

- **Feature**: Hotel Search
- **Title**: Verify the search bar allows user input and updates results with debounce
- **Priority**: High
- **Preconditions**: App is launched; API reachable
- **Test Steps**:
  1. Tap on the search bar
  2. Type `Hotel`
  3. Observe delay between input and search request (500ms)
- **Expected Result**: Results begin to show 500ms after user stops typing

---

### TS-02 – Search Pagination

- **Feature**: Hotel Search
- **Title**: Validate pagination when scrolling down
- **Priority**: High
- **Preconditions**: Multiple hotels returned by API
- **Test Steps**:
  1. Search for `New York`
  2. Scroll to bottom of results
- **Expected Result**: Next page of hotels is loaded and appended

---

### TS-03 – Add to Favorites

- **Feature**: Favorites
- **Title**: User can favorite a hotel from search results
- **Priority**: High
- **Preconditions**: Search results are displayed
- **Test Steps**:
  1. Tap heart icon on a hotel card
  2. Navigate to Favorites tab
- **Expected Result**: Favorited hotel appears in Favorites list

---

### TS-04 – State Preservation Across Tabs

- **Feature**: Navigation
- **Title**: Switching tabs preserves state
- **Priority**: High
- **Preconditions**: App running; multiple tabs used
- **Test Steps**:
  1. Perform a hotel search
  2. Switch to Favorites tab
  3. Return to Search
- **Expected Result**: Previously typed search term and results are preserved

---

## 🖼 UI/UX Tests

### TS-05 – Theme Switching

- **Feature**: Responsive Design
- **Title**: Validate light/dark mode UI
- **Priority**: High
- **Preconditions**: System theme toggled
- **Test Steps**:
  1. Switch OS theme to Dark
  2. Open app
- **Expected Result**: App adapts to dark theme styling

---

## ⚙ Platform-Specific

### TS-06 – Android Lifecycle Test

- **Feature**: Android Behavior
- **Title**: Verify app resumes correctly after backgrounding
- **Priority**: Medium
- **Preconditions**: App open on Android emulator/device
- **Test Steps**:
  1. Press Home button
  2. Reopen app
- **Expected Result**: App state is preserved; no crash

---

## 📶 Network Handling

### TS-07 – Offline Search

- **Feature**: API Integration
- **Title**: Search behavior when offline
- **Priority**: Medium
- **Preconditions**: Disable network
- **Test Steps**:
  1. Launch app
  2. Search for any term
- **Expected Result**: Graceful offline error message

---

## 🔒 Security

### TS-08 – Secure Storage of Favorites

- **Feature**: Data Security
- **Title**: Verify that favorites are stored securely (local only)
- **Priority**: High
- **Preconditions**: Add hotel to favorites
- **Test Steps**:
  1. Exit and relaunch app
- **Expected Result**: Favorites persist; data not accessible outside app storage

---

## ♿ Accessibility

### TS-09 – Screen Reader Support

- **Feature**: Accessibility
- **Title**: Hotel cards are readable via screen reader
- **Priority**: Medium
- **Preconditions**: Screen reader enabled (e.g. TalkBack or VoiceOver)
- **Test Steps**:
  1. Navigate through list using assistive tech
- **Expected Result**: Screen reader reads hotel name, rating, and price

---

## 🔁 Additional Test Suites

| Test Type         | Tool              | Execution Command                         |
|------------------|-------------------|-------------------------------------------|
| Widget Tests      | Flutter           | `./run_tests.sh widget`                   |
| Integration Tests | Flutter/Drive     | `./run_tests.sh integration`              |
| All Tests         | Flutter           | `./run_tests.sh all`                      |
| List Devices      | Flutter           | `./run_tests.sh list`                     |
| Start Emulators   | Flutter           | `./run_tests.sh start`                    |

## 🧪 Implemented Automated Tests

### Widget Tests
- **Hotel Card Test** (`test/widgets/hotel_card_test.dart`)
  - Validates the hotel card UI component
  - Tests rendering of basic hotel information:
    - Hotel name
    - Hotel description
  - Tests favorite button functionality:
    - Initial state (outline icon)
    - State change on tap
    - Updated state (filled icon)
  - Maps to Test Scenario: "UI Components"

### Integration Tests
- **App Test** (`integration_test/app_test.dart`)
  - Basic app launch and UI interaction
  - Tests initial search flow:
    - App launch
    - Hotel icon tap
    - Search input
    - Basic result display
  - Maps to Test Scenario: "Search Functionality" (partial coverage)

> Note: These are initial test implementations. More tests could be added based on the test scenarios in the plan.

---

## 📋 Manual Testing Checklist

- [ ] Search (debounce, pagination, error)
- [ ] Favorites (add/remove, persistence)
- [ ] Navigation (tab switch, back stack)
- [ ] Layouts (responsive, dark mode, text scaling)
- [ ] Performance (load time, scrolling)
- [ ] Android/iOS lifecycle
- [ ] Offline/network errors
- [ ] Security (no exposed storage)
- [ ] Accessibility (screen reader)

---

## 🧰 Precondition Summary

| Requirement       | Tools or Setup                                 |
|------------------|--------------------------------------------------|
| Emulator/Device   | Android API 31+ / iOS 13+                       |
| Flutter SDK       | Version `3.24.0` via FVM                        |
| Internet Access   | For online scenarios                            |
| Dev Mode Enabled  | For symlink and emulator debugging              |
| Java SDK          | Version 17 (or 21 with AGP fix)                 |

---