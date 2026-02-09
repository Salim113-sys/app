# Daily Reset - Customization Guide

## 🎨 Changing the App Name

### 1. Package Name
Edit `pubspec.yaml`:
```yaml
name: daily_reset  # Change this to your desired package name
```

### 2. App Display Name (Android)
Edit `android/app/src/main/AndroidManifest.xml`:
```xml
<application
    android:label="Your App Name"  <!-- Change this -->
```

### 3. App Display Name (iOS)
Edit `ios/Runner/Info.plist`:
```xml
<key>CFBundleDisplayName</key>
<string>Your App Name</string>  <!-- Change this -->
```

## 🎨 Changing Colors

All colors are centralized in `lib/theme.dart`. To customize:

### Light Mode Colors
Edit the `LightModeColors` class:
```dart
class LightModeColors {
  static const lightPrimary = Color(0xFF4ECDC4);      // Main brand color
  static const lightSecondary = Color(0xFFFF6B6B);    // Accent color
  static const lightTertiary = Color(0xFF95E1D3);     // Success/progress color
  static const lightBackground = Color(0xFFFAFAF9);   // App background
  static const lightSurface = Color(0xFFFFFFFF);      // Card background
  // ... modify other colors as needed
}
```

### Dark Mode Colors
Edit the `DarkModeColors` class:
```dart
class DarkModeColors {
  static const darkPrimary = Color(0xFF80E5DE);       // Main brand color
  static const darkSecondary = Color(0xFFFF8A80);     // Accent color
  static const darkBackground = Color(0xFF1A1F2E);    // App background
  // ... modify other colors as needed
}
```

### Color Picker Resources
- Use [Coolors.co](https://coolors.co/) to generate palettes
- Use [Material Design Color Tool](https://material.io/resources/color/) for accessible colors
- Ensure contrast ratios meet WCAG standards (4.5:1 for text)

## 🔤 Changing Fonts

### Using Google Fonts (Current)
Edit `lib/theme.dart` in the `_buildTextTheme` function:
```dart
TextTheme _buildTextTheme(Brightness brightness) {
  return TextTheme(
    displayLarge: GoogleFonts.poppins(  // Change 'inter' to your font
      fontSize: FontSizes.displayLarge,
      // ...
    ),
    // ... update all text styles with your chosen font
  );
}
```

Available Google Fonts: [fonts.google.com](https://fonts.google.com/)

### Using Custom Fonts
1. Add font files to `assets/fonts/`
2. Update `pubspec.yaml`:
```yaml
flutter:
  fonts:
    - family: YourFontName
      fonts:
        - asset: assets/fonts/YourFont-Regular.ttf
        - asset: assets/fonts/YourFont-Bold.ttf
          weight: 700
```
3. Update `theme.dart` to use your custom font

## 💰 AdMob Integration

### Where Ads Are Placed
Ad placeholders are currently in:
- **Stats Screen** (`lib/screens/stats_screen.dart`) - Bottom banner
- **Settings Screen** (`lib/screens/settings_screen.dart`) - Bottom banner

These locations were chosen to avoid interrupting the core habit tracking experience.

### Integration Steps

1. **Add AdMob dependency** to `pubspec.yaml`:
```yaml
dependencies:
  google_mobile_ads: ^5.0.0
```

2. **Initialize AdMob** in `lib/main.dart`:
```dart
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  // ... rest of initialization
}
```

3. **Add AdMob App IDs** to platform files:

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<manifest>
    <application>
        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-YOUR_PUBLISHER_ID~YOUR_APP_ID"/>
    </application>
</manifest>
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-YOUR_PUBLISHER_ID~YOUR_APP_ID</string>
```

4. **Create Banner Ad Widget** (`lib/widgets/banner_ad_widget.dart`):
```dart
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: 'YOUR_AD_UNIT_ID', // Use test ID: 'ca-app-pub-3940256099942544/6300978111'
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => _isLoaded = true),
        onAdFailedToLoad: (ad, error) {
          debugPrint('Ad failed to load: $error');
          ad.dispose();
        },
      ),
      request: const AdRequest(),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    if (_bannerAd == null || !_isLoaded) {
      return const SizedBox.shrink();
    }

    return Container(
      alignment: Alignment.center,
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}
```

5. **Replace Ad Placeholders** in stats and settings screens:
```dart
// Replace the placeholder Container with:
const BannerAdWidget()
```

### Important AdMob Notes
- Use **test ad unit IDs** during development
- Follow [AdMob policies](https://support.google.com/admob/answer/6128543) to avoid account suspension
- Don't place ads on the Home screen to keep the core experience ad-free
- Monitor ad performance and adjust placements as needed

## 📝 Modifying Motivational Quotes

Edit `lib/screens/home_screen.dart`:
```dart
String _getMotivationalQuote() {
  final quotes = [
    'Your custom quote here',
    'Another inspirational message',
    // Add more quotes...
  ];
  return quotes[DateTime.now().day % quotes.length];
}
```

## 🎯 Adding More Habit Categories

Edit `lib/models/habit.dart`:
```dart
enum HabitCategory {
  body,
  mind,
  focus,
  life,
  custom,  // Add new category
  // ...

  String get displayName {
    switch (this) {
      // ... existing cases
      case HabitCategory.custom:
        return 'Custom Name';
    }
  }

  String get emoji {
    switch (this) {
      // ... existing cases
      case HabitCategory.custom:
        return '🎨';  // Choose emoji
    }
  }
}
```

## 📊 Customizing Sample Habits

Edit `lib/services/habit_service.dart`:
```dart
List<Habit> _getSampleHabits() => [
  Habit(
    name: 'Your Habit',
    description: 'Description',
    category: HabitCategory.body,
    targetDaysPerWeek: 7,
  ),
  // Add more sample habits...
];
```

## 🔒 Updating Privacy Policy

Edit `lib/screens/privacy_policy_screen.dart` to replace the placeholder content with your actual privacy policy. Make sure to include:
- Your contact information
- Details about data collection
- Third-party services (especially AdMob)
- User rights and data handling

## 🚀 Building for Release

### Android
1. Update `android/app/build.gradle` with signing configuration
2. Update app version in `pubspec.yaml`
3. Run: `flutter build appbundle --release`

### iOS
1. Configure signing in Xcode
2. Update version in `pubspec.yaml`
3. Run: `flutter build ipa --release`

## 📱 Testing Checklist
- [ ] Test onboarding flow
- [ ] Test habit CRUD operations
- [ ] Test mood logging
- [ ] Test data persistence (close and reopen app)
- [ ] Test theme switching
- [ ] Test reset all data
- [ ] Test on different screen sizes
- [ ] Verify ads display correctly (if integrated)
- [ ] Test offline functionality

## 🎓 Next Steps
1. Set up Firebase/Supabase for cloud sync (optional)
2. Add push notifications for habit reminders
3. Implement data export functionality
4. Add more statistics and visualizations
5. Create widget for home screen
6. Add social sharing features

## 📚 Resources
- [Flutter Documentation](https://flutter.dev/docs)
- [Material Design 3](https://m3.material.io/)
- [AdMob Guidelines](https://admob.google.com/home/)
- [Google Play Publishing](https://play.google.com/console/about/guides/releasewithconfidence/)
