import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

/// Advanced local storage service for persisting data
class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  late Directory _appDocDir;
  bool _initialized = false;

  /// Initialize storage service
  Future<void> initialize() async {
    if (_initialized) return;
    _appDocDir = await getApplicationDocumentsDirectory();
    _initialized = true;
  }

  /// Save data as JSON
  Future<bool> saveJson(String key, Map<String, dynamic> data) async {
    try {
      await _ensureInitialized();
      final file = File('${_appDocDir.path}/$key.json');
      await file.writeAsString(jsonEncode(data));
      return true;
    } catch (e) {
      if (kDebugMode) print('[LocalStorage] Error saving $key: $e');
      return false;
    }
  }

  /// Load data from JSON
  Future<Map<String, dynamic>?> loadJson(String key) async {
    try {
      await _ensureInitialized();
      final file = File('${_appDocDir.path}/$key.json');
      if (!await file.exists()) return null;
      final contents = await file.readAsString();
      return jsonDecode(contents) as Map<String, dynamic>;
    } catch (e) {
      if (kDebugMode) print('[LocalStorage] Error loading $key: $e');
      return null;
    }
  }

  /// Save string data
  Future<bool> saveString(String key, String value) async {
    try {
      await _ensureInitialized();
      final file = File('${_appDocDir.path}/$key.txt');
      await file.writeAsString(value);
      return true;
    } catch (e) {
      if (kDebugMode) print('[LocalStorage] Error saving string $key: $e');
      return false;
    }
  }

  /// Load string data
  Future<String?> loadString(String key) async {
    try {
      await _ensureInitialized();
      final file = File('${_appDocDir.path}/$key.txt');
      if (!await file.exists()) return null;
      return await file.readAsString();
    } catch (e) {
      if (kDebugMode) print('[LocalStorage] Error loading string $key: $e');
      return null;
    }
  }

  /// Save list data
  Future<bool> saveList(String key, List<dynamic> data) async {
    try {
      await _ensureInitialized();
      final file = File('${_appDocDir.path}/$key.json');
      await file.writeAsString(jsonEncode(data));
      return true;
    } catch (e) {
      if (kDebugMode) print('[LocalStorage] Error saving list $key: $e');
      return false;
    }
  }

  /// Load list data
  Future<List<dynamic>?> loadList(String key) async {
    try {
      await _ensureInitialized();
      final file = File('${_appDocDir.path}/$key.json');
      if (!await file.exists()) return null;
      final contents = await file.readAsString();
      return jsonDecode(contents) as List<dynamic>;
    } catch (e) {
      if (kDebugMode) print('[LocalStorage] Error loading list $key: $e');
      return null;
    }
  }

  /// Delete specific key
  Future<bool> delete(String key) async {
    try {
      await _ensureInitialized();
      final jsonFile = File('${_appDocDir.path}/$key.json');
      final txtFile = File('${_appDocDir.path}/$key.txt');
      
      if (await jsonFile.exists()) await jsonFile.delete();
      if (await txtFile.exists()) await txtFile.delete();
      return true;
    } catch (e) {
      if (kDebugMode) print('[LocalStorage] Error deleting $key: $e');
      return false;
    }
  }

  /// Check if key exists
  Future<bool> exists(String key) async {
    try {
      await _ensureInitialized();
      final jsonFile = File('${_appDocDir.path}/$key.json');
      final txtFile = File('${_appDocDir.path}/$key.txt');
      return await jsonFile.exists() || await txtFile.exists();
    } catch (e) {
      return false;
    }
  }

  /// Clear all stored data
  Future<bool> clearAll() async {
    try {
      await _ensureInitialized();
      final dir = Directory(_appDocDir.path);
      if (await dir.exists()) {
        await for (final file in dir.list()) {
          if (file is File) {
            await file.delete();
          }
        }
      }
      return true;
    } catch (e) {
      if (kDebugMode) print('[LocalStorage] Error clearing all: $e');
      return false;
    }
  }

  /// Get storage size in bytes
  Future<int> getStorageSize() async {
    try {
      await _ensureInitialized();
      int totalSize = 0;
      final dir = Directory(_appDocDir.path);
      if (await dir.exists()) {
        await for (final file in dir.list()) {
          if (file is File) {
            totalSize += await file.length();
          }
        }
      }
      return totalSize;
    } catch (e) {
      return 0;
    }
  }

  Future<void> _ensureInitialized() async {
    if (!_initialized) await initialize();
  }
}
