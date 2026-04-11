import 'package:flutter/material.dart';

import '../models/diary_entry.dart';
import '../widgets/diary_thumbnail.dart';
import '../widgets/form_row.dart';

class CreateDiaryScreen extends StatefulWidget {
  const CreateDiaryScreen({super.key});

  @override
  State<CreateDiaryScreen> createState() => _CreateDiaryScreenState();
}

class _CreateDiaryScreenState extends State<CreateDiaryScreen> {
  final _titleCtrl = TextEditingController();
  final _imageCtrl = TextEditingController();

  DateTime _eventDate = DateTime.now();
  bool _remindLater = true;
  ReminderInterval _interval = ReminderInterval.threeMonths;
  ReminderMethod _method = ReminderMethod.ringtone;

  static String _formatDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd/$mm/${d.year}';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _eventDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _eventDate = picked);
  }

  void _submit() {
    final remind = _remindLater;
    final interval = remind ? _interval : null;
    final scheduledOneMinute = remind && interval == ReminderInterval.oneMinute
        ? DateTime.now().add(const Duration(minutes: 1))
        : null;
    final entry = DiaryEntry(
      title: _titleCtrl.text.trim().isEmpty ? 'Nhật ký' : _titleCtrl.text.trim(),
      eventDate: _eventDate,
      imagePath: _imageCtrl.text.trim().isEmpty ? null : _imageCtrl.text.trim(),
      remindLater: remind,
      reminderInterval: interval,
      reminderMethod: remind ? _method : null,
      reminderScheduledAt: scheduledOneMinute,
    );
    Navigator.of(context).pop(entry);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _imageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fieldStyle = Theme.of(context).textTheme.bodyLarge;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FormRow(
                        label: 'Tiêu đề',
                        child: TextFormField(
                          controller: _titleCtrl,
                          style: fieldStyle,
                          decoration: kDiaryOutlineFieldDecoration,
                        ),
                      ),
                      FormRow(
                        label: 'Thời gian',
                        child: Row(
                          children: [
                            Expanded(
                              child: InputDecorator(
                                decoration: kDiaryOutlineFieldDecoration,
                                child: Text(
                                  _formatDate(_eventDate),
                                  style: fieldStyle,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: _pickDate,
                              icon: const Icon(Icons.calendar_today_outlined),
                            ),
                          ],
                        ),
                      ),
                      FormRow(
                        label: 'Hình ảnh',
                        child: TextFormField(
                          controller: _imageCtrl,
                          style: fieldStyle,
                          onChanged: (_) => setState(() {}),
                          decoration: kDiaryOutlineFieldDecoration.copyWith(
                            hintText: 'Dán link http(s) để xem trước',
                          ),
                        ),
                      ),
                      if (isDiaryImageNetworkUrl(_imageCtrl.text))
                        Padding(
                          padding: const EdgeInsets.only(
                            left: kDiaryFormLabelWidth,
                            top: 4,
                            bottom: 8,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                width: double.infinity,
                                height: 200,
                                color: Colors.grey.shade100,
                                alignment: Alignment.center,
                                child: Image.network(
                                  _imageCtrl.text.trim(),
                                  key: ValueKey(_imageCtrl.text.trim()),
                                  fit: BoxFit.contain,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) =>
                                      Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.broken_image_outlined,
                                          color: Colors.grey.shade600,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Không tải được ảnh. Kiểm tra link.',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: Colors.grey.shade700,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      FormRow(
                        label: 'Nhắc lại sau này',
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Switch(
                            value: _remindLater,
                            onChanged: (v) => setState(() => _remindLater = v),
                          ),
                        ),
                      ),
                      if (_remindLater)
                        Padding(
                          padding: const EdgeInsets.only(left: kDiaryFormLabelWidth),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              DropdownButtonFormField<ReminderInterval>(
                                key: ValueKey(_interval),
                                initialValue: _interval,
                                decoration: kDiaryOutlineDropdownDecoration,
                                isExpanded: true,
                                items: ReminderInterval.values
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e.label),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) {
                                  if (v != null) setState(() => _interval = v);
                                },
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<ReminderMethod>(
                                key: ValueKey(_method),
                                initialValue: _method,
                                decoration: kDiaryOutlineDropdownDecoration,
                                isExpanded: true,
                                items: ReminderMethod.values
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e.label),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) {
                                  if (v != null) setState(() => _method = v);
                                },
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16, top: 8),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton(
                    onPressed: _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Ghi lại nhật ký'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
