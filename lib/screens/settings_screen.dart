import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daily_reset/theme.dart';
import 'package:daily_reset/providers/theme_provider.dart';
import 'package:daily_reset/providers/habit_provider.dart';
import 'package:daily_reset/providers/daily_log_provider.dart';
import 'package:daily_reset/providers/hydration_provider.dart';
import 'package:daily_reset/providers/workout_provider.dart';
import 'package:daily_reset/providers/movement_provider.dart';
import 'package:daily_reset/providers/deep_work_provider.dart';
import 'package:daily_reset/services/notification_service.dart';
import 'package:daily_reset/components/core/components.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const DRAppBar(title: 'Settings'),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const DRSectionHeader(
                    title: 'Appearance',
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const _ThemeSelector(),
                  const SizedBox(height: AppSpacing.sm),
                  const DRSectionHeader(
                    title: 'Notifications',
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const _NotificationSection(),
                  const SizedBox(height: AppSpacing.sm),
                  const DRSectionHeader(
                    title: 'Premium Features',
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const _PremiumFeaturesSection(),
                  const SizedBox(height: AppSpacing.sm),
                  const DRSectionHeader(
                    title: 'Data & Privacy',
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const _DataSection(),
                  const SizedBox(height: AppSpacing.xxl),
                  Center(
                    child: Text(
                      'Daily Reset v1.0.0',
                      style: context.textStyles.labelMedium?.withColor(
                        theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector();

  @override
  Widget build(BuildContext context) {
    return DRCard(
      padding: AppSpacing.paddingSm,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildThemeOption(context, 'Light', Icons.wb_sunny_rounded,
                AppTheme.light, Colors.orange),
            const SizedBox(width: 8),
            _buildThemeOption(context, 'Dark', Icons.dark_mode_rounded,
                AppTheme.dark, Colors.purple),
            const SizedBox(width: 8),
            _buildThemeOption(
                context, 'Calm', Icons.spa_rounded, AppTheme.calm, Colors.teal),
            const SizedBox(width: 8),
            _buildThemeOption(context, 'Sunrise', Icons.wb_twilight_rounded,
                AppTheme.sunrise, const Color(0xFFFF9F7F)),
            const SizedBox(width: 8),
            _buildThemeOption(context, 'Ocean', Icons.water_drop_rounded,
                AppTheme.ocean, const Color(0xFF00B4D8)),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(BuildContext context, String title, IconData icon,
      AppTheme mode, Color color) {
    final themeProvider = context.watch<ThemeProvider>();
    final theme = Theme.of(context);
    final isSelected = themeProvider.currentTheme == mode;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => themeProvider.setTheme(mode),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.15)
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? color
                  : theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? color : theme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: context.textStyles.labelLarge?.copyWith(
                  color: isSelected ? color : theme.colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PremiumFeaturesSection extends StatelessWidget {
  const _PremiumFeaturesSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DRCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: DRListTile(
              title: 'Focus Mode',
              showChevron: true,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.timer_outlined,
                  color: theme.colorScheme.primary,
                ),
              ),
              onTap: () => context.push('/focus'),
            ),
          ),
          Divider(
            height: 1,
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: DRListTile(
              title: 'Breathing Exercise',
              showChevron: true,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.air, color: theme.colorScheme.secondary),
              ),
              onTap: () => context.push('/breathing'),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationSection extends StatefulWidget {
  const _NotificationSection();

  @override
  State<_NotificationSection> createState() => _NotificationSectionState();
}

class _NotificationSectionState extends State<_NotificationSection> {
  bool _remindersEnabled = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      setState(() {
        _remindersEnabled = prefs.getBool('daily_reminders_enabled') ?? true;
      });
    } catch (e) {
      debugPrint('Error loading notification settings: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _toggleReminders(bool value) async {
    setState(() {
      _remindersEnabled = value;
    });
    final notif = context.read<NotificationService>();
    final habitProvider = context.read<HabitProvider>();
    final hydrationProvider = context.read<HydrationProvider>();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_reminders_enabled', value);

    if (!value) {
      await notif.cancelAllManagedReminders();
    } else {
      for (final habit in habitProvider.habits) {
        await notif.scheduleHabitReminders(habit);
      }
      final hydrationSettings = hydrationProvider.settings;
      if (hydrationSettings.remindersEnabled) {
        await notif.scheduleHydrationReminders(
          startMinutes: hydrationSettings.reminderStartMinutes,
          endMinutes: hydrationSettings.reminderEndMinutes,
          intervalMinutes: hydrationSettings.reminderIntervalMinutes,
        );
      }
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                value ? 'Notifications enabled' : 'Notifications disabled')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Only fetch the service to call methods, we don't need to watch it for state changes
    final notif = context.read<NotificationService>();
    final theme = Theme.of(context);

    return DRCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          MouseRegion(
            cursor:
                _isLoading ? SystemMouseCursors.basic : SystemMouseCursors.click,
            child: DRListTile(
              title: 'Daily Reminders',
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.notifications_active,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
              trailing: Switch.adaptive(
                value: _remindersEnabled,
                onChanged: _isLoading ? null : _toggleReminders,
              ),
              onTap: _isLoading ? null : () => _toggleReminders(!_remindersEnabled),
            ),
          ),
          Divider(
            height: 1,
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
          MouseRegion(
            cursor: _remindersEnabled
                ? SystemMouseCursors.click
                : SystemMouseCursors.basic,
            child: DRListTile(
              title: 'Test Notification',
              showChevron: true,
              isEnabled: _remindersEnabled,
              onTap: _remindersEnabled
                  ? () async {
                      try {
                        await notif.scheduleOneTimeTestNotificationInOneMinute();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Test scheduled for 1 min from now'),
                            ),
                          );
                        }
                      } catch (e) {
                        debugPrint('Error: $e');
                      }
                    }
                  : null,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DataSection extends StatefulWidget {
  const _DataSection();

  @override
  State<_DataSection> createState() => _DataSectionState();
}

class _DataSectionState extends State<_DataSection> {
  bool _isResetting = false;

  Future<void> factoryResetApp() async {
    if (_isResetting) return;

    setState(() {
      _isResetting = true;
    });

    try {
      final notificationService = context.read<NotificationService>();
      final habitProvider = context.read<HabitProvider>();
      final dailyLogProvider = context.read<DailyLogProvider>();
      final hydrationProvider = context.read<HydrationProvider>();
      final workoutProvider = context.read<WorkoutProvider>();
      final themeProvider = context.read<ThemeProvider>();
      final habitIds =
          habitProvider.habits.map((h) => h.id).toList(growable: false);

      MovementProvider? movementProvider;
      DeepWorkProvider? deepWorkProvider;
      try {
        movementProvider = context.read<MovementProvider>();
      } on ProviderNotFoundException catch (_) {
        debugPrint('MovementProvider not registered; skipping provider reset.');
      }
      try {
        deepWorkProvider = context.read<DeepWorkProvider>();
      } on ProviderNotFoundException catch (_) {
        debugPrint('DeepWorkProvider not registered; skipping provider reset.');
      }
      final prefs = await SharedPreferences.getInstance();

      // Cancel all app-managed notifications first.
      await notificationService.cancelAllManagedReminders();
      for (final habitId in habitIds) {
        await notificationService.cancelHabitReminders(habitId);
      }
      await notificationService.cancelHydrationReminders();
      await notificationService.cancelMovementReminders();
      await notificationService.cancelDeepWorkReminders();

      // Clear provider-backed domains and in-memory state.
      await habitProvider.clearAllData();
      await dailyLogProvider.clearAllData();
      await hydrationProvider.clearAllData();
      await workoutProvider.clearAllData();
      if (movementProvider != null) {
        await movementProvider.clearAllData();
      }
      if (deepWorkProvider != null) {
        await deepWorkProvider.clearAllData();
      }

      // Product intent: preserve onboarding_completed, reset app_theme_mode to
      // system, and reset daily_reminders_enabled to true.
      // Explicit key removal for all reset domains.
      const keysToRemove = <String>[
        'habits',
        'daily_logs',
        'hydration_settings_v1',
        'movement_settings_v1',
        'movement_session_logs_v1',
        'deep_work_settings_v1',
        'workout_session_logs_v1',
        'app_theme_mode',
        'daily_reminders_enabled',
        'managed_notification_ids',
      ];
      for (final key in keysToRemove) {
        await prefs.remove(key);
      }

      final prefixedKeys = prefs
          .getKeys()
          .where(
            (key) =>
                key.startsWith('hydration_entries_') ||
                key.startsWith('deep_work_entries_'),
          )
          .toList(growable: false);
      for (final key in prefixedKeys) {
        await prefs.remove(key);
      }

      // Reset post-reset defaults.
      await prefs.setBool('daily_reminders_enabled', true);
      await themeProvider.setTheme(AppTheme.system);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All data has been reset.')),
      );
      context.go('/');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reset failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isResetting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DRCard(
      padding: EdgeInsets.zero,
      child: MouseRegion(
        cursor:
            _isResetting ? SystemMouseCursors.basic : SystemMouseCursors.click,
        child: DRListTile(
          key: const Key('settings_reset_all_data_tile'),
          title: 'Reset All Data',
          isDestructive: true,
          showChevron: true,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.delete_outline, color: theme.colorScheme.error),
          ),
          onTap: _isResetting ? null : () => _showResetDataDialog(context),
        ),
      ),
    );
  }

  void _showResetDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        key: const Key('settings_reset_dialog'),
        title: const Text('Reset Everything?'),
        content: const Text(
          'This will permanently delete all your tracking history and habits. This action cannot be undone.',
        ),
        actions: [
          DRButtonGhost(
            label: 'Cancel',
            onPressed: () => Navigator.pop(context),
          ),
          DRButtonDestructive(
            key: const Key('settings_confirm_reset_button'),
            label: 'Reset Data',
            onPressed: _isResetting
                ? null
                : () async {
                    Navigator.pop(context); // Close dialog
                    await factoryResetApp();
                  },
          ),
        ],
      ),
    );
  }
}
