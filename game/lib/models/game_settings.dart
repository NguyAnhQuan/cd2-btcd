/// Model: cấu hình game đố vui (lưu/đọc JSON).
class GameSettings {
  const GameSettings({
    required this.isSoundOn,
    required this.highScore,
    required this.isAutoSaveEnabled,
    required this.volume,
  });

  final bool isSoundOn;
  final int highScore;
  final bool isAutoSaveEnabled;

  /// 0.0 – 1.0
  final double volume;

  static const String jsonSound = 'isSoundOn';
  static const String jsonHighScore = 'highScore';
  static const String jsonAutoSave = 'isAutoSaveEnabled';
  static const String jsonVolume = 'volume';

  factory GameSettings.defaults() => const GameSettings(
        isSoundOn: true,
        highScore: 3500,
        isAutoSaveEnabled: true,
        volume: 0.35,
      );

  GameSettings copyWith({
    bool? isSoundOn,
    int? highScore,
    bool? isAutoSaveEnabled,
    double? volume,
  }) {
    return GameSettings(
      isSoundOn: isSoundOn ?? this.isSoundOn,
      highScore: highScore ?? this.highScore,
      isAutoSaveEnabled: isAutoSaveEnabled ?? this.isAutoSaveEnabled,
      volume: volume ?? this.volume,
    );
  }

  Map<String, dynamic> toJson() => {
        jsonSound: isSoundOn,
        jsonHighScore: highScore,
        jsonAutoSave: isAutoSaveEnabled,
        jsonVolume: volume,
      };

  factory GameSettings.fromJson(Map<String, dynamic> json) {
    return GameSettings(
      isSoundOn: json[jsonSound] as bool? ?? true,
      highScore: (json[jsonHighScore] as num?)?.toInt() ?? 3500,
      isAutoSaveEnabled: json[jsonAutoSave] as bool? ?? true,
      volume: (json[jsonVolume] as num?)?.toDouble().clamp(0.0, 1.0) ?? 0.35,
    );
  }
}
