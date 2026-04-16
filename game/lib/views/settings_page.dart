import 'package:flutter/material.dart';

import '../controllers/settings_controller.dart';

/// View: màn hình cấu hình (chỉ UI + gọi controller).
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.controller});

  final SettingsController controller;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onController);
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await widget.controller.initialize();
    if (mounted) setState(() {});
  }

  void _onController() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onController);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (!c.isReady) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: colorScheme.primary),
        ),
      );
    }

    final s = c.settings;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
        title: const Text('Cấu hình game đố vui'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Text(
            'Cấu hình game đố vui',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 0,
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  secondary: CircleAvatar(
                    backgroundColor: colorScheme.primaryContainer,
                    child: Icon(
                      s.isSoundOn ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  title: const Text('Âm thanh'),
                  subtitle: Text(s.isSoundOn ? 'Đang bật' : 'Đang tắt'),
                  value: s.isSoundOn,
                  onChanged: (v) => c.setSoundOn(v),
                ),
                const Divider(height: 1, indent: 72),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: colorScheme.tertiaryContainer,
                    child: Icon(
                      Icons.emoji_events_rounded,
                      color: colorScheme.onTertiaryContainer,
                    ),
                  ),
                  title: const Text('Điểm cao nhất'),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${s.highScore}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1, indent: 72),
                SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  secondary: CircleAvatar(
                    backgroundColor: colorScheme.secondaryContainer,
                    child: Icon(
                      Icons.save_rounded,
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),
                  title: const Text('Tự động lưu game'),
                  subtitle: Text(s.isAutoSaveEnabled ? 'Đang bật' : 'Đang tắt'),
                  value: s.isAutoSaveEnabled,
                  onChanged: (v) => c.setAutoSaveEnabled(v),
                ),
                const Divider(height: 1, indent: 16),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.tune_rounded,
                            size: 22,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Volume',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${(s.volume * 100).round()}%',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 4,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 10,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 18,
                          ),
                        ),
                        child: Slider(
                          value: s.volume,
                          onChanged: (v) => c.setVolume(v),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Cấu hình được lưu tự động dưới dạng JSON trên thiết bị.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
