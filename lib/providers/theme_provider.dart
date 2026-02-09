import 'package:flutter/material.dart';
import 'package:daily_reset/services/storage_service.dart';
import 'package:daily_reset/theme.dart';

enum AppTheme {
  system,
  light,
  dark,
  calm,
  sunrise,
  ocean
}

class ThemeProvider extends ChangeNotifier {
  static const String _storageKey = 'app_theme_mode'; // Changed key to avoid conflict or just migration
  final StorageService _storage;
  AppTheme _currentTheme = AppTheme.system;

  ThemeProvider(this._storage) {
    _loadTheme();
  }

  AppTheme get currentTheme => _currentTheme;

  // Returns true if effective theme is dark
  bool get isDarkMode {
    if (_currentTheme == AppTheme.dark) return true;
    if (_currentTheme == AppTheme.calm) return false;
    if (_currentTheme == AppTheme.light) return false;
    // System
    return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
  }

  // Returns the ThemeData to Use
  ThemeData get themeData {
    switch (_currentTheme) {
      case AppTheme.calm:
        return calmTheme;
      case AppTheme.sunrise:
        return sunriseTheme;
      case AppTheme.ocean:
        return oceanTheme;
      case AppTheme.dark:
        return darkTheme;
      case AppTheme.light:
        return lightTheme;
      case AppTheme.system:
        final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
        return brightness == Brightness.dark ? darkTheme : lightTheme;
    }
  }

  Future<void> _loadTheme() async {
    final saved = _storage.getString(_storageKey);
    if (saved != null) {
      _currentTheme = AppTheme.values.firstWhere(
        (e) => e.name == saved,
        orElse: () => AppTheme.system,
      );
      notifyListeners();
    }
  }

  Future<void> setTheme(AppTheme theme) async {
    _currentTheme = theme;
    await _storage.saveString(_storageKey, theme.name);
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    // Cycle: System -> Light -> Calm -> Dark -> System (or just Light->Dark->Calm?)
    // Let's keep it simple: if Dark -> Light. If Light -> Calm. If Calm -> Dark.
    switch (_currentTheme) {
      case AppTheme.dark:
        await setTheme(AppTheme.light);
        break;
      case AppTheme.light:
        await setTheme(AppTheme.calm);
        break;
      case AppTheme.calm:
        await setTheme(AppTheme.sunrise);
        break;
      case AppTheme.sunrise:
        await setTheme(AppTheme.ocean);
        break;
      case AppTheme.ocean:
        await setTheme(AppTheme.dark);
        break;
      case AppTheme.system:
        await setTheme(AppTheme.light);
        break;
    }
  }
}
