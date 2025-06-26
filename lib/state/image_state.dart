import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

enum UploadStatus { idle, pending, uploading, success, failed }

class QueuedImage {
  final Uint8List bytes;
  UploadStatus status;
  QueuedImage(this.bytes, {this.status = UploadStatus.pending});
}

class ImageState extends ChangeNotifier {
  final List<QueuedImage> _queue = [];
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  late final Connectivity _connectivity;
  late final Stream<ConnectivityResult> _connectivityStream;

  ImageState() {
    _connectivity = Connectivity();
    _connectivityStream = _connectivity.onConnectivityChanged;
    _connectivityStream.listen(_onConnectivityChanged);
    _initNotifications();
  }

  List<QueuedImage> get queue => List.unmodifiable(_queue);

  Future<void> _initNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: android);
    await _notifications.initialize(initSettings);
  }

  Future<void> _showNotification() async {
    const android = AndroidNotificationDetails(
      'upload_channel', 'Uploads',
      importance: Importance.max, priority: Priority.high,
    );
    const notifDetails = NotificationDetails(android: android);
    await _notifications.show(
      0, 'Upload Complete', 'Your image was uploaded successfully!', notifDetails);
  }

  void addImages(List<Uint8List> images) {
    for (var img in images) {
      _queue.add(QueuedImage(img));
    }
    notifyListeners();
    _tryUpload();
  }

  Future<void> _onConnectivityChanged(ConnectivityResult result) async {
    if (result != ConnectivityResult.none) {
      await _tryUpload();
    }
  }

  Future<void> _tryUpload() async {
    final connectivity = await _connectivity.checkConnectivity();
    if (connectivity == ConnectivityResult.none) return;

    for (var img in _queue.where((q) => q.status == UploadStatus.pending)) {
      img.status = UploadStatus.uploading;
      notifyListeners();
      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('https://httpbin.org/post'),
        );
        request.files.add(
          http.MultipartFile.fromBytes('file', img.bytes, filename: 'image.jpg'),
        );
        var response = await request.send();
        if (response.statusCode == 200) {
          img.status = UploadStatus.success;
          await _showNotification();
        } else {
          img.status = UploadStatus.failed;
        }
      } catch (e) {
        img.status = UploadStatus.failed;
      }
      notifyListeners();
    }
  }

  void retryUpload(int index) {
    if (_queue[index].status == UploadStatus.failed) {
      _queue[index].status = UploadStatus.pending;
      notifyListeners();
      _tryUpload();
    }
  }
}