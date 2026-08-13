import 'dart:convert';
import 'package:http/http.dart' as http;

class AiPolishService {
  static const String _baseUrl =
      'https://1448765384-1mhcarowyk.ap-beijing.tencentscf.com';
  static const String _authToken = 'sk_proxy_2026_secure';

  static Future<String> polishText(String text, {String? context}) async {
    if (text.trim().isEmpty) {
      throw Exception('文本不能为空');
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/polish'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
        body: jsonEncode({
          'text': text,
          'context': context ?? '',
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return data['polished'] as String;
      } else {
        throw Exception(data['error'] ?? '润色失败，请稍后重试');
      }
    } catch (e) {
      throw Exception('网络请求失败: $e');
    }
  }
}