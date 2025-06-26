# Offline Image Upload (Flutter)

A Flutter app that allows users to select multiple images and upload them, even when offline. Images are queued in memory and automatically uploaded when the device regains connectivity. Users receive local notifications upon successful upload.

---

## Features

- **Multiple Image Selection:** Pick multiple images from the gallery.
- **Offline Support:** Images selected while offline are stored in memory and queued for upload.
- **Auto Upload:** Images are automatically uploaded when the internet connection is restored.
- **Upload Queue:** See the status of each image (Pending, Uploading, Success, Failed).
- **Retry Failed Uploads:** Retry uploading any failed images.
- **Local Notifications:** Get notified when an image is successfully uploaded.
- **Modern UI:** Amazon-inspired dark theme with animated card corners.

---

## Screenshots

*(Add your screenshots here)*

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Android Studio or VS Code

### Installation

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

## Project Structure

- `lib/ui/home_screen.dart` — Main UI for image selection and upload queue.
- `lib/state/image_state.dart` — State management for image queue and upload logic.
- `android/` — Android-specific configuration.
- `pubspec.yaml` — Project dependencies.

---

## Dependencies

- [provider](https://pub.dev/packages/provider)
- [image_picker](https://pub.dev/packages/image_picker)
- [connectivity_plus](https://pub.dev/packages/connectivity_plus)
- [http](https://pub.dev/packages/http)
- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
- [google_fonts](https://pub.dev/packages/google_fonts)

---

## Approach

- **State Management:** Uses Provider for managing the image queue and upload status.
- **Connectivity:** Uses connectivity_plus to listen for network changes.
- **Upload:** Sends images as multipart/form-data to a mock endpoint (`https://httpbin.org/post`).
- **Notifications:** Uses flutter_local_notifications to notify users of successful uploads.
- **UI:** Modern, responsive, and visually appealing.

---

## License

This project is for educational purposes.