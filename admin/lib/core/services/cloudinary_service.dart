import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class CloudinaryService {
  static const String _cloudName = 'dssmutzly';
  static const String _uploadPreset = 'multimallpro';
  static const String _cloudinaryUrl = 'https://api.cloudinary.com/v1_1/$_cloudName/image/upload';

  final Dio _dio = Dio();

  Future<String?> uploadImage(XFile file) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromBytes(
          await file.readAsBytes(), 
          filename: file.name.isNotEmpty ? file.name : 'upload.jpg'
        ),
        'upload_preset': _uploadPreset,
      });

      final response = await _dio.post(_cloudinaryUrl, data: formData);

      if (response.statusCode == 200) {
        String url = response.data['secure_url'];
        // Insert auto-quality and auto-format transformations
        return url.replaceFirst('/upload/', '/upload/q_auto:best,f_auto/');
      }
      return null;
    } catch (e) {
      print('Cloudinary Upload Error: $e');
      return null;
    }
  }
}
