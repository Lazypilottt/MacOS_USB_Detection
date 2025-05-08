# 🔌 USB Detection App for macOS

A macOS SwiftUI application that detects USB devices in real time using IOKit, displaying detailed information such as name, vendor ID, product ID, serial number, and BSD path.

---

## 📸 Preview

> A simple SwiftUI interface lists connected USB devices as soon as they are plugged in or removed.

---

## 🚀 Features

- 🔍 Real-time USB device detection
- 🧠 Uses `IOKit` under the hood (via `USBWatcher`)
- 🧼 Clean SwiftUI interface
- 🖥 Device metadata displayed:
  - Product Name
  - Vendor ID
  - Product ID
  - Serial Number (if available)
  - BSD Path (if available)

---

## 🛠 Requirements

- macOS 12 or later
- Xcode 13+
- Swift 5.5+
- `IOKit` framework

---

## 📁 Project Structure

MacOS_USB_Detection/
│
├── USBWatcher.swift              # Registers IOKit notifications for USB events
├── USBDevice.swift               # USB device data model
├── io_object_t+Extension.swift   # Extension to extract USB info from io_object_t
├── ContentView.swift             # SwiftUI-based UI for displaying devices
└── USB_DETECTION_APP_V1App.swift # App entry point


---

## 🧑‍💻 How It Works

- `USBWatcher` uses `IOServiceAddMatchingNotification` to listen for:
  - `kIOFirstMatchNotification` (device connected)
  - `kIOTerminatedNotification` (device removed)
- Connected devices are parsed using `IORegistryEntryCreateCFProperties`
- The UI automatically reflects changes via `@StateObject` in `ContentView`

---

## 🔧 Setup & Run

1. Clone the repository:
   git clone https://github.com/yourusername/MacOS_USB_Detection.git
   cd MacOS_USB_Detection
2. Open the .xcodeproj or .xcodeworkspace in Xcode.
   
3. Build and run the app on your Mac (real devices only; won't work in iOS or simulators).
*(Make sure you enable access to USB devices if prompted in System Preferences > Security & Privacy.)*



Pull requests are welcome! If you have ideas for enhancements (like ejecting devices or filtering by vendor), feel free to contribute.
