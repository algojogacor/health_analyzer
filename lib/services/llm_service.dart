import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LlmProviderPreset {
  final String id;
  final String label;
  final String defaultBaseUrl;
  final String defaultModel;
  final String description;

  const LlmProviderPreset({
    required this.id,
    required this.label,
    required this.defaultBaseUrl,
    required this.defaultModel,
    required this.description,
  });

  static const deepseek = LlmProviderPreset(
    id: 'deepseek',
    label: 'DeepSeek',
    defaultBaseUrl: 'https://api.deepseek.com',
    defaultModel: 'deepseek-chat',
    description: 'Default cloud preset. Uses an OpenAI-compatible chat API.',
  );

  static const openai = LlmProviderPreset(
    id: 'openai',
    label: 'OpenAI',
    defaultBaseUrl: 'https://api.openai.com/v1',
    defaultModel: 'gpt-4.1-mini',
    description: 'OpenAI-compatible endpoint. Requires your own API key.',
  );

  static const groq = LlmProviderPreset(
    id: 'groq',
    label: 'Groq',
    defaultBaseUrl: 'https://api.groq.com/openai/v1',
    defaultModel: 'llama-3.3-70b-versatile',
    description: 'Fast OpenAI-compatible provider. Requires your own API key.',
  );

  static const cerebras = LlmProviderPreset(
    id: 'cerebras',
    label: 'Cerebras',
    defaultBaseUrl: 'https://api.cerebras.ai/v1',
    defaultModel: 'llama-3.3-70b',
    description: 'OpenAI-compatible provider. Requires your own API key.',
  );

  static const custom = LlmProviderPreset(
    id: 'custom_openai',
    label: 'Custom',
    defaultBaseUrl: 'https://your-provider.example/v1',
    defaultModel: 'model-name',
    description: 'Any provider exposing an OpenAI-compatible chat endpoint.',
  );

  static const all = [deepseek, openai, groq, cerebras, custom];

  static LlmProviderPreset byId(String? id) {
    return all.firstWhere((preset) => preset.id == id, orElse: () => deepseek);
  }
}

class LlmSettings {
  final String providerId;
  final String baseUrl;
  final String apiKey;
  final String model;

  const LlmSettings({
    required this.providerId,
    required this.baseUrl,
    required this.apiKey,
    required this.model,
  });

  LlmProviderPreset get preset => LlmProviderPreset.byId(providerId);

  String get providerLabel =>
      providerId == LlmProviderPreset.custom.id
          ? 'Custom provider'
          : preset.label;

  bool get isConfigured =>
      apiKey.trim().isNotEmpty &&
      model.trim().isNotEmpty &&
      baseUrl.trim().isNotEmpty;

  String get normalizedBaseUrl =>
      baseUrl.trim().replaceFirst(RegExp(r'/+$'), '');

  String get chatCompletionsUrl {
    final base = normalizedBaseUrl;
    if (base.endsWith('/chat/completions')) return base;
    return '$base/chat/completions';
  }
}

class LlmChatCompletion {
  final String content;
  final int inputTokens;
  final int outputTokens;

  const LlmChatCompletion({
    required this.content,
    this.inputTokens = 0,
    this.outputTokens = 0,
  });
}

class LlmService {
  static const providerStorageKey = 'llm_provider_id';
  static const baseUrlStorageKey = 'llm_base_url';
  static const apiKeyStorageKey = 'llm_api_key';
  static const modelStorageKey = 'llm_model';

  static const legacyDeepSeekApiKeyStorageKey = 'deepseek_api_key';
  static const legacyDeepSeekModelStorageKey = 'deepseek_model';

  final FlutterSecureStorage storage;
  final Dio _dio;

  LlmService({required this.storage, Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 20),
              receiveTimeout: const Duration(seconds: 60),
            ),
          );

  Future<LlmSettings> loadSettings() async {
    final storedProvider = await storage.read(key: providerStorageKey);
    final storedBaseUrl = await storage.read(key: baseUrlStorageKey);
    final storedApiKey = await storage.read(key: apiKeyStorageKey);
    final storedModel = await storage.read(key: modelStorageKey);

    final legacyApiKey = await storage.read(
      key: legacyDeepSeekApiKeyStorageKey,
    );
    final legacyModel = await storage.read(key: legacyDeepSeekModelStorageKey);

    if ((storedApiKey == null || storedApiKey.trim().isEmpty) &&
        legacyApiKey != null &&
        legacyApiKey.trim().isNotEmpty) {
      final migrated = LlmSettings(
        providerId: LlmProviderPreset.deepseek.id,
        baseUrl: LlmProviderPreset.deepseek.defaultBaseUrl,
        apiKey: legacyApiKey,
        model:
            legacyModel?.trim().isNotEmpty == true
                ? legacyModel!.trim()
                : LlmProviderPreset.deepseek.defaultModel,
      );
      await saveSettings(
        providerId: migrated.providerId,
        baseUrl: migrated.baseUrl,
        apiKey: migrated.apiKey,
        model: migrated.model,
      );
      return migrated;
    }

    final preset = LlmProviderPreset.byId(storedProvider);
    return LlmSettings(
      providerId: preset.id,
      baseUrl:
          storedBaseUrl?.trim().isNotEmpty == true
              ? storedBaseUrl!.trim()
              : preset.defaultBaseUrl,
      apiKey: storedApiKey ?? '',
      model:
          storedModel?.trim().isNotEmpty == true
              ? storedModel!.trim()
              : preset.defaultModel,
    );
  }

  Future<void> saveSettings({
    required String providerId,
    required String baseUrl,
    required String apiKey,
    required String model,
  }) async {
    final preset = LlmProviderPreset.byId(providerId);
    final resolvedBaseUrl =
        baseUrl.trim().isEmpty ? preset.defaultBaseUrl : baseUrl.trim();
    final resolvedModel =
        model.trim().isEmpty ? preset.defaultModel : model.trim();

    await Future.wait([
      storage.write(key: providerStorageKey, value: preset.id),
      storage.write(key: baseUrlStorageKey, value: resolvedBaseUrl),
      storage.write(key: apiKeyStorageKey, value: apiKey.trim()),
      storage.write(key: modelStorageKey, value: resolvedModel),
    ]);

    if (preset.id == LlmProviderPreset.deepseek.id) {
      await Future.wait([
        storage.write(
          key: legacyDeepSeekApiKeyStorageKey,
          value: apiKey.trim(),
        ),
        storage.write(key: legacyDeepSeekModelStorageKey, value: resolvedModel),
      ]);
    }
  }

  Future<LlmChatCompletion> chatCompletion({
    required List<Map<String, String>> messages,
    double temperature = 0.3,
    LlmSettings? settings,
  }) async {
    final resolved = settings ?? await loadSettings();
    if (!resolved.isConfigured) {
      throw StateError(
        'Cloud LLM API key, base URL, or model is not configured',
      );
    }

    final response = await _dio.post(
      resolved.chatCompletionsUrl,
      options: Options(
        headers: {
          'Authorization': 'Bearer ${resolved.apiKey}',
          'Content-Type': 'application/json',
        },
      ),
      data: {
        'model': resolved.model,
        'messages': messages,
        'temperature': temperature,
      },
    );
    final data = response.data;
    if (data is! Map) {
      throw StateError('Cloud LLM returned an unsupported response');
    }
    final choices = data['choices'] as List<dynamic>?;
    final message =
        choices?.isEmpty == false ? choices!.first['message'] : null;
    final content = message is Map ? message['content'] : null;
    final text = _contentToText(content);
    if (text.trim().isEmpty) {
      throw StateError('Cloud LLM returned an empty response');
    }
    final usage = data['usage'];
    return LlmChatCompletion(
      content: text,
      inputTokens: _usageInt(usage, 'prompt_tokens'),
      outputTokens: _usageInt(usage, 'completion_tokens'),
    );
  }

  Future<String> chat({
    required List<Map<String, String>> messages,
    double temperature = 0.3,
    LlmSettings? settings,
  }) async {
    final completion = await chatCompletion(
      messages: messages,
      temperature: temperature,
      settings: settings,
    );
    return completion.content;
  }

  String _contentToText(Object? content) {
    if (content == null) return '';
    if (content is String) return content;
    if (content is List) {
      return content
          .map((part) {
            if (part is Map && part['text'] != null) return part['text'];
            return part.toString();
          })
          .join('\n');
    }
    return content.toString();
  }

  int _usageInt(Object? usage, String key) {
    if (usage is! Map) return 0;
    final value = usage[key];
    if (value is int) return value;
    if (value is num) return value.round();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
