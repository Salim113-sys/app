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
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: context.textStyles.headlineSmall?.semiBold,
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: AppSpacing.paddingLg,
        children: [
          _buildsectionHeader(context, 'Appearance'),
          const SizedBox(height: AppSpacing.md),
          const _ThemeSelector(),
          const SizedBox(height: AppSpacing.xl),
          _buildsectionHeader(context, 'Notifications'),
          const SizedBox(height: AppSpacing.md),
          const _NotificationSection(),
          const SizedBox(height: AppSpacing.xl),
          _buildsectionHeader(context, 'Data & Privacy'),
          const SizedBox(height: AppSpacing.md),
          const _DataSection(),
          const SizedBox(height: AppSpacing.xl),
          _buildsectionHeader(context, 'Premium Features'),
          const SizedBox(height: AppSpacing.md),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color:
                      theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.timer_outlined,
                    color: theme.colorScheme.primary),
              ),
              title: const Text('Focus Mode'),
              subtitle: const Text('Start a deep work session'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/focus'),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color:
                      theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.air, color: theme.colorScheme.secondary),
              ),
              title: const Text('Breathing Exercise'),
              subtitle: const Text('4-4-4-4 Box Breathing'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/breathing'),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Center(
            child: Text(
              'Daily Reset v1.0.0',
              style: context.textStyles.labelMedium?.withColor(
                theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildsectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: context.textStyles.titleMedium?.bold.withColor(
          Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildThemeOption(context, 'Light', Icons.wb_sunny_rounded,
              AppTheme.light, Colors.orange),
          const SizedBox(width: 12),
          _buildThemeOption(context, 'Dark', Icons.dark_mode_rounded,
              AppTheme.dark, Colors.purple),
          const SizedBox(width: 12),
          _buildThemeOption(
              context, 'Calm', Icons.spa_rounded, AppTheme.calm, Colors.teal),
          const SizedBox(width: 12),
          _buildThemeOption(context, 'Sunrise', Icons.wb_twilight_rounded,
              AppTheme.sunrise, const Color(0xFFFF9F7F)),
          const SizedBox(width: 12),
          _buildThemeOption(context, 'Ocean', Icons.water_drop_rounded,
              AppTheme.ocean, const Color(0xFF00B4D8)),
        ],
      ),
    );
  }

  Widget _buildThemeOption(BuildContext context, String title, IconData icon,
      AppTheme mode, Color color) {
    final themeProvider = context.watch<ThemeProvider>();
    final theme = Theme.of(context);
    final isSelected = themeProvider.currentTheme == mode;

    return GestureDetector(
      onTap: () => themeProvider.setTheme(mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : theme.colorScheme.onSurfaceVariant,
              size: 28,
            ),
            const SizedBox(height: 8),
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

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Daily Reminders'),
            subtitle: const Text('Get notified to complete your check-in'),
            value: _remindersEnabled,
            onChanged: _isLoading ? null : _toggleReminders,
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.notifications_active,
                  color: theme.colorScheme.onSecondaryContainer),
            ),
          ),
          Divider(
              height: 1,
              indent: 60,
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
          ListTile(
            title: const Text('Test Notification'),
            subtitle: const Text('Send a test alert in 1 min'),
            trailing: const Icon(Icons.chevron_right),
            enabled: _remindersEnabled,
            onTap: () async {
              try {
                await notif.scheduleOneTimeTestNotificationInOneMinute();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Test scheduled for 1 min from now')),
                  );
                }
              } catch (e) {
                debugPrint('Error: $e');
              }
            },
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

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          ListTile(
            key: const Key('settings_reset_all_data_tile'),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.delete_outline, color: theme.colorScheme.error),
            ),
            title: Text(
              'Reset All Data',
              style: TextStyle(color: theme.colorScheme.error),
            ),
            subtitle: const Text('Clear habits, logs, and progress'),
            onTap: _isResetting ? null : () => _showResetDataDialog(context),
          ),
        ],
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
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            key: const Key('settings_confirm_reset_button'),
            onPressed: _isResetting
                ? null
                : () async {
                    Navigator.pop(context); // Close dialog
                    await factoryResetApp();
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Reset Data'),
          ),
        ],
      ),
    );
  }
}
