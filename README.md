# Offline Image Upload (Flutter)

A Flutter app that allows users to select multiple images and upload them, even when offline. Images are queued in memory and automatically uploaded when the device regains connectivity. Users receive local notifications upon successful upload.

---

## 🚀 How to Set Up the Project

1. **Clone the repository:**
   ```sh
   git clone <your-repo-url>
   cd offline_image_upload
   ```

2. **Install dependencies:**
   ```sh
   flutter pub get
   ```

3. **Run the app:**
   ```sh
   flutter run
   ```

4. **Build APK (for Android):**
   ```sh
   flutter build apk --release
   ```

---

## ✨ Key Features

- **Multiple Image Selection:** Pick multiple images from the gallery.
- **Offline Support:** Images selected while offline are stored in memory and queued for upload.
- **Auto Upload:** Images are automatically uploaded when the internet connection is restored.
- **Upload Queue:** See the status of each image (Pending, Uploading, Success, Failed).
- **Retry Failed Uploads:** Retry uploading any failed images.
- **Local Notifications:** Get notified when an image is successfully uploaded.
- **Modern UI:** Amazon-inspired dark theme with animated card corners.

---

## ⚠️ Limitations & Assumptions

- **In-Memory Only:** Images are not persisted to disk; if the app is killed, the upload queue is lost.
- **No Background Upload:** Uploads only occur while the app is running and in the foreground.
- **No Per-Image Progress Bar:** Only a simple indicator is shown; per-image upload progress could be added.
- **No Image Compression:** Images are uploaded at their original size.
- **No iOS Local Notification Support:** Local notifications are currently set up for Android; iOS support may require additional configuration.
- **No User Authentication:** All uploads are anonymous.
- **No Error Details:** Failed uploads do not show detailed error messages.
- **No Disk Caching:** For true offline robustness, consider adding optional disk caching (if requirements change).

---

## 📦 Flutter Packages Used

- [`provider`](https://pub.dev/packages/provider)
- [`image_picker`](https://pub.dev/packages/image_picker)
- [`connectivity_plus`](https://pub.dev/packages/connectivity_plus)
- [`http`](https://pub.dev/packages/http)
- [`flutter_local_notifications`](https://pub.dev/packages/flutter_local_notifications)
- [`google_fonts`](https://pub.dev/packages/google_fonts)

---

## 🛠️ Potential Future Improvements

- Persist the upload queue to disk for true offline robustness.
- Add background upload support.
- Show per-image upload progress.
- Add image compression before upload.
- Support for iOS notifications.
- Add authentication and user profiles.
- Display error details and allow users to remove images from the queue.

---