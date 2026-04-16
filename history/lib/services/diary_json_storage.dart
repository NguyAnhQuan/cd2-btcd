import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/diary_entry.dart';

/// Lưu / đọc danh sách nhật ký từ file JSON trong thư mục dữ liệu ứng dụng.
class DiaryJsonStorage {
  DiaryJsonStorage._();

  static const _fileName = 'diaries.json';

  static Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  static Future<List<DiaryEntry>> load() async {
    try {
      final f = await _file();
      if (!await f.exists()) return [];
      final text = await f.readAsString();
      if (text.trim().isEmpty) return [];
      final decoded = jsonDecode(text);
      if (decoded is! Map<String, dynamic>) return [];
      final list = decoded['entries'];
      if (list is! List) return [];
      final out = <DiaryEntry>[];
      for (final item in list) {
        if (item is! Map<String, dynamic>) continue;
        try {
          out.add(DiaryEntry.fromJson(item));
        } catch (_) {
          // bỏ qua bản ghi hỏng
        }
      }
      return out;
    } catch (_) {
      return [];
    }
  }

  static Future<void> save(List<DiaryEntry> entries) async {
    final f = await _file();
    final map = {
      'version': 1,
      'entries': entries.map((e) => e.toJson()).toList(),
    };
    await f.writeAsString(const JsonEncoder.withIndent('  ').convert(map));
  }
}
