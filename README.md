# Aadhaar FaceRD Flutter Plugin

A Flutter plugin for integrating **UIDAI Aadhaar FaceRD** on **Android and iOS**, enabling secure Aadhaar face authentication using the official **CAPTURE interface**.

> ⚠️ **Disclaimer**
>
> - This plugin is **NOT an official UIDAI SDK**
> - Use only if you are a **UIDAI-authorised AUA / KUA**
> - All biometric capture, liveness checks, and encryption are handled **only by the UIDAI FaceRD app**
> - This plugin **never accesses, stores, or transmits biometric data**

---

## ✨ Features

✅ Android FaceRD integration via secure intent  
✅ iOS FaceRD integration using UIDAI **headless URL scheme**  
✅ UIDAI-compliant **PID Options XML builder**  
✅ FaceRD app installation check  
✅ No biometric data captured or stored by the plugin  
✅ Backend-first, **audit-safe architecture**  
✅ Works on both **Android and iOS**

---

## 📱 Platform Behavior

### Android
- FaceRD is launched via **intent**
- Encrypted PID **may be returned** to the app
- App can proceed immediately after capture

### iOS (Important)
- FaceRD runs in **headless mode**
- Face capture & PID generation happen **inside FaceRD app**
- PID is sent **directly to backend** using `callbackUrl`
- App does **NOT reliably receive PID**
- User must **manually return** to the app
- App should **poll backend using `txnId`**

👉 This behavior is **mandated by UIDAI and Apple security policies**.

---

## 📘 Detailed Documentation

- 📱 iOS FaceRD Flow  
  `doc/ios_face_rd_flow.md`

- 🧠 Backend Integration (Mandatory for iOS)  
  `doc/backend_integration.md`

---

## 🚀 Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  aadhaar_face_rd: ^0.1.3
  ```


## ⚙️ Platform Setup
Android Setup (REQUIRED)
Android 11+ Package Visibility

Android 11 and above require explicit package visibility for FaceRD.

Add the following inside your AndroidManifest.xml:

```
<queries>
    <package android:name="in.gov.uidai.facerd" />
    <intent>
        <action android:name="in.gov.uidai.rdservice.face.CAPTURE" />
    </intent>
</queries>
```

❗ Without this configuration, FaceRD installation checks will fail on Android 11+.


## iOS Setup (REQUIRED)
1️⃣ Info.plist Configuration

Add the following entries to Info.plist:

```
<!-- Allow querying Aadhaar FaceRD URL scheme -->
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>FaceRDLib</string>
</array>

<!-- Callback URL scheme for your app -->
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>face_rd_callback</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>face_rddemo</string>
        </array>
    </dict>
</array>

```

This is mandatory to:

Detect FaceRD installation

Launch FaceRD using the CAPTURE URL scheme

# Aadhaar FaceRD Example App

This example demonstrates how to use the `aadhaar_face_rd` plugin
on both **Android and iOS**, including iOS lifecycle handling.

## Structure

```
example/lib/
├── main.dart
│ Entry point for the example app
│
├── services/facerd_service.dart
│ Wrapper around AadhaarFaceRd plugin
│ - Installation check
│ - Launch FaceRD
│ - Stream handling
│
└── screens/face_rd_demo_page.dart
UI layer
- Launch FaceRD
- iOS app resume handling
- Backend polling trigger (txnId based)

```
