import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DeepSeekSettings {
  final String apiKey;
  final String model;

  const DeepSeekSettings({required this.apiKey, required this.model});

  bool get isConfigured => apiKey.trim().isNotEmpty;
}

class DeepSeekService {
  static const apiKeyStorageKey = 'deepseek_api_key';
  static const modelStorageKey = 'deepseek_model';
  static const defaultModel = 'deepseek-chat';

  final FlutterSecureStorage storage;
  final Dio _dio;

  DeepSeekService({required this.storage, Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: 'https://api.deepseek.com',
              connectTimeout: const Duration(seconds: 20),
              receiveTimeout: const Duration(seconds: 60),
            ),
          );

  Future<DeepSeekSettings> loadSettings() async {
    return DeepSeekSettings(
      apiKey: await storage.read(key: apiKeyStorageKey) ?? '',
      model: await storage.read(key: modelStorageKey) ?? defaultModel,
    );
  }

  Future<void> saveSettings({
    required String apiKey,
    required String model,
  }) async {
    await Future.wait([
      storage.write(key: apiKeyStorageKey, value: apiKey.trim()),
      storage.write(
        key: modelStorageKey,
        value: model.trim().isEmpty ? defaultModel : model.trim(),
      ),
    ]);
  }

  Future<String> chat({
    required List<Map<String, String>> messages,
    double temperature = 0.3,
  }) async {
    final settings = await loadSettings();
    if (!settings.isConfigured) {
      throw StateError('DeepSeek API key is not configured');
    }
    final response = await _dio.post(
      '/chat/completions',
      options: Options(headers: {'Authorization': 'Bearer ${settings.apiKey}'}),
      data: {
        'model': settings.model,
        'messages': messages,
        'temperature': temperature,
      },
    );
    final choices = response.data['choices'] as List<dynamic>?;
    final message =
        choices?.isEmpty == false ? choices!.first['message'] : null;
    final content = message is Map ? message['content'] : null;
    if (content == null || content.toString().trim().isEmpty) {
      throw StateError('DeepSeek returned an empty response');
    }
    return content.toString();
  }
}
