import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

/// Ngoại lệ hiển thị trực tiếp thông báo tiếng Việt cho người dùng.
class GeminiImageException implements Exception {
  final String message;
  const GeminiImageException(this.message);

  @override
  String toString() => message;
}

/// Gọi Gemini API (mô hình sinh ảnh) để tạo minh họa lá bài Tarot theo prompt.
class GeminiImageService {
  static const _model = 'gemini-2.5-flash-image';
  static const _endpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent';

  /// Gửi [prompt] (đã được ép cứng phong cách Tarot) tới Gemini và trả về
  /// bytes ảnh PNG/JPEG sinh ra. Ném [GeminiImageException] với thông báo
  /// tiếng Việt nếu có lỗi.
  static Future<Uint8List> generateTarotImage({
    required String apiKey,
    required String prompt,
  }) async {
    final uri = Uri.parse('$_endpoint?key=$apiKey');

    late final http.Response response;
    try {
      response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'contents': [
                {
                  'parts': [
                    {'text': prompt},
                  ],
                },
              ],
            }),
          )
          .timeout(const Duration(seconds: 60));
    } catch (e) {
      throw const GeminiImageException(
        'Không kết nối được tới Gemini. Kiểm tra lại mạng internet rồi thử lại.',
      );
    }

    if (response.statusCode == 400) {
      throw const GeminiImageException(
        'API key không hợp lệ hoặc yêu cầu bị từ chối. Kiểm tra lại API key ở aistudio.google.com.',
      );
    }
    if (response.statusCode == 403) {
      throw const GeminiImageException(
        'API key không có quyền dùng tính năng tạo ảnh. Kiểm tra lại API key.',
      );
    }
    if (response.statusCode == 429) {
      throw const GeminiImageException(
        'Đã vượt giới hạn số lần gọi Gemini miễn phí. Thử lại sau ít phút.',
      );
    }
    if (response.statusCode != 200) {
      throw GeminiImageException(
        'Gemini trả về lỗi (mã ${response.statusCode}). Thử lại sau.',
      );
    }

    Map<String, dynamic> data;
    try {
      data = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw const GeminiImageException('Không đọc được phản hồi từ Gemini.');
    }

    final candidates = data['candidates'] as List<dynamic>?;
    if (candidates == null || candidates.isEmpty) {
      final blockReason = data['promptFeedback']?['blockReason'];
      if (blockReason != null) {
        throw const GeminiImageException(
          'Mô tả của bạn bị Gemini từ chối vì vi phạm chính sách nội dung. Hãy thử mô tả khác.',
        );
      }
      throw const GeminiImageException('Gemini không trả về kết quả nào. Thử lại.');
    }

    final parts = candidates.first['content']?['parts'] as List<dynamic>?;
    if (parts == null) {
      throw const GeminiImageException('Gemini không trả về nội dung ảnh.');
    }

    for (final part in parts) {
      final inlineData = part['inlineData'] ?? part['inline_data'];
      if (inlineData != null && inlineData['data'] != null) {
        return base64Decode(inlineData['data'] as String);
      }
    }

    throw const GeminiImageException(
      'Gemini chỉ trả về văn bản, không có ảnh. Hãy thử mô tả rõ ràng hơn về hình ảnh mong muốn.',
    );
  }
}
