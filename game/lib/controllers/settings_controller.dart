import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../models/game_settings.dart';

/// Controller: đọc/ghi JSON và cập nhật model.
class SettingsController extends ChangeNotifier {
  SettingsController() : _memoryOnly = false;

  /// Không đọc/ghi file (dùng cho widget test / preview).
  SettingsController.testing([GameSettings? initial])
      : _memoryOnly = true,
        _settings = initial ?? GameSettings.defaults(),
        _ready = true;

  final bool _memoryOnly;

  GameSettings _settings = GameSettings.defaults();
  GameSettings get settings => _settings;

  bool _ready = false;
  bool get isReady => _ready;

  static const String _fileName = 'game_settings.json';

  Future<void> initialize() async {
    if (_memoryOnly) {
      notifyListeners();
      return;
    }
    try {
      await _load();
    } catch (_) {
      _settings = GameSettings.defaults();
    }
    _ready = true;
    notifyListeners();
  }

  Future<File> _settingsFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}${Platform.pathSeparator}$_fileName');
  }

  Future<void> _load() async {
    try {
      final file = await _settingsFile();
      if (!await file.exists()) {
        _settings = GameSettings.defaults();
        await _save();
        return;
      }
      final text = await file.readAsString();
      final map = jsonDecode(text) as Map<String, dynamic>;
      _settings = GameSettings.fromJson(map);
    } catch (_) {
      _settings = GameSettings.defaults();
    }
  }

  Future<void> _save() async {
    if (_memoryOnly) return;
    final file = await _settingsFile();
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(_settings.toJson()),
    );
  }

  Future<void> setSoundOn(bool value) async {
    _settings = _settings.copyWith(isSoundOn: value);
    notifyListeners();
    await _save();
  }

  Future<void> setAutoSaveEnabled(bool value) async {
    _settings = _settings.copyWith(isAutoSaveEnabled: value);
    notifyListeners();
    await _save();
  }

  Future<void> setVolume(double value) async {
    _settings = _settings.copyWith(volume: value.clamp(0.0, 1.0));
    notifyListeners();
    await _save();
  }

  /// Cập nhật điểm cao (gọi từ logic game khi cần).
  Future<void> setHighScore(int value) async {
    if (value <= _settings.highScore) return;
    _settings = _settings.copyWith(highScore: value);
    notifyListeners();
    await _save();
  }
}
