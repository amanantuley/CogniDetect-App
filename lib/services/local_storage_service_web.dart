import 'dart:convert';
import 'dart:html' as html;

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  bool _initialized = false;

  Future<void> initialize() async {
    _initialized = true;
  }

  Future<void> _ensureInitialized() async {
    if (!_initialized) await initialize();
  }

  Future<bool> saveJson(String key, Map<String, dynamic> data) async {
    try {
      await _ensureInitialized();
      html.window.localStorage[key] = jsonEncode(data);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> loadJson(String key) async {
    try {
      await _ensureInitialized();
      final value = html.window.localStorage[key];
      if (value == null) return null;
      return jsonDecode(value) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<bool> saveString(String key, String value) async {
    try {
      await _ensureInitialized();
      html.window.localStorage[key] = value;
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<String?> loadString(String key) async {
    await _ensureInitialized();
    return html.window.localStorage[key];
  }

  Future<bool> saveList(String key, List<dynamic> data) async {
    try {
      await _ensureInitialized();
      html.window.localStorage[key] = jsonEncode(data);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<List<dynamic>?> loadList(String key) async {
    try {
      await _ensureInitialized();
      final value = html.window.localStorage[key];
      if (value == null) return null;
      return jsonDecode(value) as List<dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<bool> delete(String key) async {
    try {
      await _ensureInitialized();
      html.window.localStorage.remove(key);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> exists(String key) async {
    await _ensureInitialized();
    return html.window.localStorage.containsKey(key);
  }

  Future<bool> clearAll() async {
    try {
      await _ensureInitialized();
      html.window.localStorage.clear();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<int> getStorageSize() async {
    await _ensureInitialized();
    int total = 0;
    html.window.localStorage.forEach((_, value) => total += value.length);
    return total;
  }
}
