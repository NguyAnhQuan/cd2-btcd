import 'package:flutter/material.dart';

import '../models/diary_entry.dart';
import '../services/diary_json_storage.dart';
import '../services/diary_notifications.dart';
import '../widgets/diary_thumbnail.dart';
import 'create_diary_screen.dart';

/// Thứ tự hiển thị danh sách nhật ký.
enum _DiarySort {
  /// Thứ tự thêm vào (mới nhất do insert(0) nằm trên).
  defaultOrder,
  titleAZ,
  titleZA,
  dateNewest,
  dateOldest,
}

class DiaryListScreen extends StatefulWidget {
  const DiaryListScreen({super.key});

  @override
  State<DiaryListScreen> createState() => _DiaryListScreenState();
}

class _DiaryListScreenState extends State<DiaryListScreen> {
  final List<DiaryEntry> _entries = [];
  bool _storageReady = false;

  _DiarySort _sort = _DiarySort.defaultOrder;

  @override
  void initState() {
    super.initState();
    _loadFromDisk();
  }

  Future<void> _loadFromDisk() async {
    try {
      final list = await DiaryJsonStorage.load();
      if (!mounted) return;
      setState(() {
        _entries
          ..clear()
          ..addAll(list);
        _storageReady = true;
      });
      await diaryNotificationsSyncWithEntries(_entries);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _entries.clear();
        _storageReady = true;
      });
      await diaryNotificationsSyncWithEntries(_entries);
    }
  }

  Future<void> _persist() async {
    await DiaryJsonStorage.save(_entries);
    await diaryNotificationsSyncWithEntries(_entries);
  }

  List<DiaryEntry> get _visibleEntries {
    final list = List<DiaryEntry>.from(_entries);
    switch (_sort) {
      case _DiarySort.defaultOrder:
        return list;
      case _DiarySort.titleAZ:
        list.sort(
          (a, b) => _compareTitle(a.title, b.title),
        );
        return list;
      case _DiarySort.titleZA:
        list.sort(
          (a, b) => _compareTitle(b.title, a.title),
        );
        return list;
      case _DiarySort.dateNewest:
        list.sort(
          (a, b) => b.eventDate.compareTo(a.eventDate),
        );
        return list;
      case _DiarySort.dateOldest:
        list.sort(
          (a, b) => a.eventDate.compareTo(b.eventDate),
        );
        return list;
    }
  }

  /// So sánh theo bảng chữ cái (Unicode), phù hợp tiếng Việt cơ bản.
  static int _compareTitle(String a, String b) =>
      a.toLowerCase().compareTo(b.toLowerCase());

  Future<void> _openCreate() async {
    final created = await Navigator.of(context).push<DiaryEntry>(
      MaterialPageRoute(builder: (context) => const CreateDiaryScreen()),
    );
    if (created != null && mounted) {
      setState(() => _entries.insert(0, created));
      await _persist();
    }
  }

  Future<void> _deleteEntry(DiaryEntry entry) async {
    setState(() => _entries.remove(entry));
    await _persist();
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visibleEntries;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('Nhật ký'),
        actions: [
          PopupMenuButton<_DiarySort>(
            tooltip: 'Sắp xếp / lọc',
            icon: const Icon(Icons.sort),
            initialValue: _sort,
            onSelected: (v) => setState(() => _sort = v),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: _DiarySort.defaultOrder,
                child: Text('Mặc định (mới thêm trước)'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: _DiarySort.titleAZ,
                child: Text('Tiêu đề: A → Z'),
              ),
              const PopupMenuItem(
                value: _DiarySort.titleZA,
                child: Text('Tiêu đề: Z → A'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: _DiarySort.dateNewest,
                child: Text('Ngày: mới nhất trước'),
              ),
              const PopupMenuItem(
                value: _DiarySort.dateOldest,
                child: Text('Ngày: cũ nhất trước'),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: !_storageReady
            ? Center(
                child: Text(
                  'Đang tải...',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.black54,
                      ),
                ),
              )
            : visible.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Chưa có nhật ký.\nBấm nút + để thêm.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black54,
                        ),
                  ),
                ),
              )
            : ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: visible.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final entry = visible[index];
                  final showThumb =
                      isDiaryImageNetworkUrl(entry.imagePath);
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showThumb) ...[
                        DiaryListThumbnail(imageUrl: entry.imagePath!),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: Text(
                          entry.title,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        tooltip: 'Xóa',
                        color: Colors.black54,
                        onPressed: () => _deleteEntry(entry),
                      ),
                    ],
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreate,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
