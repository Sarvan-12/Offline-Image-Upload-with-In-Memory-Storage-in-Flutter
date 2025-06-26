

## 🚧 Design Decisions

- **🧠 In-Memory Queue:** Images selected offline are kept in memory (RAM) using Provider state management, ensuring no disk/database writes and instant responsiveness.
- **🌐 Connectivity Handling:** The app uses real-time connectivity status to trigger auto-upload when the network is restored.
- **📡 User Feedback:** Upload status is shown for each image, and local notifications inform users of successful uploads.
- **🎨 Modern UI:** Inspired by Amazon’s dark theme, with animated card corners for visual feedback and a bold, accessible header.
- **🧱 Separation of Concerns:** UI, state management, and upload logic are separated for maintainability and clarity.

...

## Flutter Packages Used

- [`provider`](https://pub.dev/packages/provider): State management for the image queue and upload status.
- [`image_picker`](https://pub.dev/packages/image_picker): For selecting multiple images from the device gallery.
- [`connectivity_plus`](https://pub.dev/packages/connectivity_plus): To detect and respond to network connectivity changes.
- [`http`](https://pub.dev/packages/http): For making multipart/form-data POST requests to the mock upload endpoint.
- [`flutter_local_notifications`](https://pub.dev/packages/flutter_local_notifications): To send local notifications on successful upload.
- [`google_fonts`](https://pub.dev/packages/google_fonts): For modern, readable typography.

---

## Known Limitations & Future Improvements

- **In-Memory Only:** Images are not persisted to disk; if the app is killed, the upload queue is lost.
- **No Background Upload:** Uploads only occur while the app is running and in the foreground.
- **No Progress Bar for Each Upload:** Only a simple indicator is shown; per-image upload progress could be added.
- **No Image Compression:** Images are uploaded at their original size; compression could reduce bandwidth.
- **No iOS Local Notification Support:** Local notifications are currently set up for Android; iOS support may require additional configuration.
- **No User Authentication:** All uploads are anonymous; authentication could be added for real-world use.
- **No Error Details:** Failed uploads do not show detailed error messages.
- **No Disk Caching:** For true offline robustness, consider adding optional disk caching (if requirements change).

**Potential Future Improvements:**
- Persist the upload queue to disk for true offline robustness.
- Add background upload support.
- Show per-image upload progress.
- Add image compression before upload.
- Support for iOS notifications.
- Add authentication and user profiles.
- Display error details and allow users to remove images from the queue.

---