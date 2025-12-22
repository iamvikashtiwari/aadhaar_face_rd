# Aadhaar FaceRD Backend Integration Guide

This document explains the **backend responsibilities and APIs** required for
integrating Aadhaar FaceRD with a Flutter application, especially for **iOS
headless flow**.

This backend flow is **mandatory** for iOS and **recommended** for Android.

---

## ⚠️ Important Notice

- This plugin is **NOT an official UIDAI SDK**
- Use only if you are a **UIDAI-authorised AUA / KUA**
- Backend must comply with **UIDAI data retention & security guidelines**
- Never log, cache, or persist biometric data beyond required time

---

## 🧠 Why Backend Is Mandatory (Especially for iOS)

On iOS:
- FaceRD does NOT return PID data to the mobile app
- PID is sent **directly to backend** using `callbackUrl`
- App can only poll backend using `txnId`

Hence, backend acts as:
- **Receiver of encrypted PID**
- **Temporary secure store**
- **Verifier for mobile app**
- **Gateway to Aadhaar Auth / eKYC APIs**

---

## 🧭 End-to-End Backend Flow

