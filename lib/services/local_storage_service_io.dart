import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  Directory? _appDocDir;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    _appDocDir = await getApplicationDocumentsDirectory();
    _initialized = true;
  }

  Future<void> _ensureInitialized() async {
    if (!_initialized) await initialize();
  }

  Future<bool> saveJson(String key, Map<String, dynamic> data) async {
    try {
      await _ensureInitialized();
      final file = File('${_appDocDir!.path}/$key.json');
      await file.writeAsString(jsonEncode(data));
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> loadJson(String key) async {
    try {
      await _ensureInitialized();
      final file = File('${_appDocDir!.path}/$key.json');
      if (!await file.exists()) return null;
      final contents = await file.readAsString();
      return jsonDecode(contents) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<bool> saveString(String key, String value) async {
    try {
      await _ensureInitialized();
      final file = File('${_appDocDir!.path}/$key.txt');
      await file.writeAsString(value);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<String?> loadString(String key) async {
    try {
      await _ensureInitialized();
      final file = File('${_appDocDir!.path}/$key.txt');
      if (!await file.exists()) return null;
      return await file.readAsString();
    } catch (_) {
      return null;
    }
  }

  Future<bool> saveList(String key, List<dynamic> data) async {
    try {
      await _ensureInitialized();
      final file = File('${_appDocDir!.path}/$key.json');
      await file.writeAsString(jsonEncode(data));
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<List<dynamic>?> loadList(String key) async {
    try {
      await _ensureInitialized();
      final file = File('${_appDocDir!.path}/$key.json');
      if (!await file.exists()) return null;
      final contents = await file.readAsString();
      return jsonDecode(contents) as List<dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<bool> delete(String key) async {
    try {
      await _ensureInitialized();
      final jsonFile = File('${_appDocDir!.path}/$key.json');
      final txtFile = File('${_appDocDir!.path}/$key.txt');
      if (await jsonFile.exists()) await jsonFile.delete();
      if (await txtFile.exists()) await txtFile.delete();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> exists(String key) async {
    try {
      await _ensureInitialized();
      final jsonFile = File('${_appDocDir!.path}/$key.json');
      final txtFile = File('${_appDocDir!.path}/$key.txt');
      return await jsonFile.exists() || await txtFile.exists();
    } catch (_) {
      return false;
    }
  }

  Future<bool> clearAll() async {
    try {
      await _ensureInitialized();
      final dir = Directory(_appDocDir!.path);
      if (await dir.exists()) {
        await for (final file in dir.list()) {
          if (file is File) {
            await file.delete();
          }
        }
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<int> getStorageSize() async {
    try {
      await _ensureInitialized();
      int totalSize = 0;
      final dir = Directory(_appDocDir!.path);
      if (await dir.exists()) {
        await for (final file in dir.list()) {
          if (file is File) {
            totalSize += await file.length();
          }
        }
      }
      return totalSize;
    } catch (_) {
      return 0;
    }
  }
}
