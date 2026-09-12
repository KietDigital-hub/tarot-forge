import 'package:shared_preferences/shared_preferences.dart';

/// Lưu và đọc Gemini API key của người dùng NGAY TRÊN THIẾT BỊ/TRÌNH DUYỆT của họ.
/// Key không được gửi lên GitHub hay bất kỳ máy chủ nào của Tarot Forge —
/// chỉ dùng để gọi trực tiếp từ app tới Google Gemini.
class GeminiApiKeyStore {
  static const _prefsKey = 'gemini_api_key';

  static Future<String?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(_prefsKey);
    return (key == null || key.trim().isEmpty) ? null : key.trim();
  }

  static Future<void> save(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, apiKey.trim());
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
  }
}
