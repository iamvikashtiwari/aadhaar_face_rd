# Aadhaar FaceRD iOS Integration – Complete Guide (Headless Flow)

This document explains the **complete iOS integration flow** for Aadhaar FaceRD,
including Flutter app behavior, user journey, backend interaction, and UIDAI
constraints.

This behavior is **mandated by UIDAI and Apple security policies** and is **not a
limitation of this Flutter plugin**.

---

## ⚠️ Important Notice

- This plugin is **NOT an official UIDAI SDK**
- Use only if you are a **UIDAI-authorised AUA / KUA**
- All biometric capture and encryption is handled **only by UIDAI FaceRD app**
- The Flutter app **never accesses biometric data**

---

## 🔐 Why FaceRD Works Differently on iOS

Apple does **not allow third-party apps** to:

- Capture biometric data directly
- Share biometric data between apps
- Reliably exchange biometric data via URL callbacks
- Run biometric services in background

To comply with these restrictions, UIDAI provides **FaceRD as a headless iOS app**.

### What “Headless” Means

- FaceRD launches in foreground
- Face capture and liveness happen inside FaceRD
- PID is generated and encrypted inside FaceRD
- PID is **NOT returned to the invoking app**
- PID is sent **directly to backend**
- User returns to the app **manually**

This design is **intentional and mandatory**.

---

## 🧭 End-to-End iOS Flow

