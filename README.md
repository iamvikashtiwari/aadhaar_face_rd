# Aadhaar FaceRD Flutter Plugin

A Flutter plugin for integrating **UIDAI Aadhaar FaceRD** on **Android and iOS**, enabling secure Aadhaar face authentication using the official **CAPTURE** interface.

> ⚠️ **This plugin is NOT an official UIDAI SDK.**  
> ⚠️ **Use only if you are a UIDAI-authorised AUA / KUA.**

---

## ✨ Features

- Android FaceRD integration via secure intent
- iOS FaceRD integration using UIDAI headless URL scheme
- UIDAI-compliant PID XML builder
- FaceRD app installation check
- No biometric data captured or stored by the plugin
- Backend-first, audit-safe design

---

## 📱 Platform Behavior

### Android
- FaceRD is launched via intent
- Encrypted PID **may be returned to the app**
- App can proceed immediately after capture

### iOS (Important)
- FaceRD runs in **headless mode**
- Face capture & PID generation happen **inside FaceRD app**
- PID is sent **directly to backend** using `callbackUrl`
- App **does not reliably receive PID**
- User **must manually return** to the app
- App should **poll backend using `txnId`**

This behavior is mandated by **UIDAI and Apple security policies**.

📘 **For detailed iOS behavior, see:**  
`doc/ios_face_rd_flow.md`
`doc/backend_integration.md`

---

## 🚀 Installation

```yaml
dependencies:
  aadhaar_face_rd: ^0.1.0
