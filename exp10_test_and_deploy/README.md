# Exp 10 – Test and deploy a production-ready Flutter app on Android
Uses the Exp 9 project (`../exp09_firebase_attendance`). Steps: run on Pixel 7 emulator, verify Firestore data, build release APK, install with ADB.
```
flutter doctor
flutter devices
flutter clean
flutter pub get
flutter build apk --release
adb devices
adb install -r build\app\outputs\flutter-apk\app-release.apk
```
Output: `build/app/outputs/flutter-apk/app-release.apk` (~48.7 MB).
