import 'dart:typed_data';
import 'package:http/http.dart' as http;

class UploadService {
  static Future<bool> uploadImage(Uint8List data) async {
    var uri = Uri.parse("https://httpbin.org/post");
    var req = http.MultipartRequest('POST', uri)
      ..files.add(http.MultipartFile.fromBytes('file', data, filename: 'img.jpg'));
    var res = await req.send();
    return res.statusCode == 200;
  }
}
