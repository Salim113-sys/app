# Daily Reset – Micro Habits & Mood Tracker

A production-ready Flutter mobile app that helps busy people reset each day with tiny habits and quick mood check-ins for calm, focus, and control.

## ✨ Features

### Core Functionality
- **📝 Habit Tracking**: Add, edit, and delete custom habits with categories (Body, Mind, Focus, Life)
- **😊 Mood Logging**: Track your daily mood with 5 emoji levels
- **📊 Progress Stats**: View habit streaks, weekly completion rates, and 7-day mood trends
- **🎯 Daily Reset**: Clean, focused home screen for checking off today's habits
- **🌓 Dark Mode**: Beautiful light and dark themes with smooth transitions
- **💾 Local Storage**: All data persists locally using shared_preferences

### User Experience
- **Onboarding**: Smooth 3-page introduction for first-time users
- **Modern UI**: Calming teal and coral color palette with generous spacing
- **Intuitive Navigation**: Bottom navigation bar with Home, Stats, and Settings
- **Empty States**: Friendly messages and clear calls-to-action
- **Form Validation**: Robust input validation for habit creation
- **Confirmation Dialogs**: Safe delete and reset operations

## 🎨 Design Philosophy

- **Calming Colors**: Soft teal (#4ECDC4) for calm, coral (#FF6B6B) for motivation
- **Generous Spacing**: 16-24px between sections for breathing room
- **Rounded Corners**: 16px border radius for a softer, modern feel
- **No Heavy Shadows**: Flat design with subtle borders
- **Emoji-Forward**: Visual category and mood indicators
- **Inter Font**: Clean, readable typography throughout

## 📱 Screenshots

### Light Mode
- Home screen with mood selector and habit checklist
- Stats screen with streaks and weekly completion
- Habits management with category chips
- Settings with theme toggle

### Dark Mode
- Deep navy background (#1A1F2E) for comfortable night viewing
- Adjusted colors maintain readability and vibrancy

## 🏗️ Architecture

### Project Structure
```
lib/
├── main.dart                 # App entry point
├── router.dart               # Navigation configuration
├── theme.dart                # Colors, fonts, spacing
├── models/                   # Data models
│   ├── habit.dart
│   └── daily_log.dart
├── services/                 # Data layer
│   ├── storage_service.dart
│   ├── habit_service.dart
│   └── daily_log_service.dart
├── providers/                # State management
│   ├── theme_provider.dart
│   ├── habit_provider.dart
│   └── daily_log_provider.dart
├── screens/                  # UI screens
│   ├── onboarding_screen.dart
│   ├── main_app_screen.dart
│   ├── home_screen.dart
│   ├── stats_screen.dart
│   ├── settings_screen.dart
│   ├── habits_list_screen.dart
│   ├── habit_form_screen.dart
│   └── privacy_policy_screen.dart
└── widgets/                  # Reusable components
    ├── mood_selector.dart
    ├── habit_card.dart
    ├── stat_card.dart
    ├── mood_trend_chart.dart
    └── empty_state.dart
```

### Tech Stack
- **Framework**: Flutter 3.6+
- **State Management**: Provider
- **Navigation**: go_router
- **Storage**: shared_preferences
- **Fonts**: Google Fonts (Inter)
- **Date Formatting**: intl

### Data Models
- **Habit**: id, name, description, category, targetDaysPerWeek, timestamps
- **DailyLog**: id, date, mood, completedHabitIds, timestamps
- **Enums**: HabitCategory (Body/Mind/Focus/Life), MoodLevel (5 levels)

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.6.0 or higher
- Android Studio / VS Code with Flutter extension
- Android device or emulator for testing

### Installation
1. Clone the repository
```bash
git clone <your-repo-url>
cd daily_reset
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

### First Launch
- Onboarding screens will appear on first launch
- Sample habits are automatically created
- Start by selecting your mood and checking off habits!

## 🎨 Customization

See **CUSTOMIZATION_GUIDE.md** for detailed instructions on:
- Changing app name and branding
- Customizing colors and fonts
- Integrating AdMob ads
- Modifying sample data
- Adding new features

### Quick Color Change
Edit `lib/theme.dart`:
```dart
// Light mode primary color
static const lightPrimary = Color(0xFF4ECDC4);  // Change this
static const lightSecondary = Color(0xFFFF6B6B); // And this
```

## 💰 Monetization

AdMob integration points are prepared in:
- **Stats Screen**: Banner ad placeholder at bottom
- **Settings Screen**: Banner ad placeholder at bottom

The home screen is kept ad-free to maintain the core user experience.

See CUSTOMIZATION_GUIDE.md for complete AdMob setup instructions.

## 📊 Key Stats

- **Habit Streaks**: Days in a row a habit is completed
- **Weekly Completion**: Percentage of last 7 days completed
- **Mood Trend**: Visual chart of last 7 days' moods
- **Real-time Updates**: Stats refresh as you complete habits

## 🔒 Privacy & Data

- **Local Storage Only**: No cloud, no servers, no accounts
- **Full User Control**: Reset all data anytime in Settings
- **Privacy Policy**: Customizable placeholder included
- **No Analytics**: No tracking unless you add it

## 🔧 Settings Features

- **Theme Toggle**: Switch between light and dark mode
- **Reset Data**: Clear all habits and logs with confirmation
- **Privacy Policy**: Easy access to legal information
- **About Section**: App version and description

## 📝 Development Notes

### Sample Data
5 sample habits are created on first launch:
- Morning Stretch (Body, 7x/week)
- Drink Water (Body, 7x/week)
- Gratitude Journal (Mind, 5x/week)
- Deep Work Session (Focus, 5x/week)
- Evening Walk (Life, 4x/week)

### Data Persistence
- Habits stored in: `habits` key
- Daily logs stored in: `daily_logs` key
- Theme preference: `theme_mode` key
- Onboarding status: `onboarding_completed` key

### State Management
Provider pattern with three main providers:
- ThemeProvider: Theme mode state
- HabitProvider: Habit CRUD operations
- DailyLogProvider: Mood and completion tracking

## 🐛 Known Limitations

- No cloud sync (local device only)
- No push notifications
- No data export feature
- No habit reminders
- No custom habit icons
- No social features

These are intentional for MVP but can be added in future versions.

## 🎯 Future Enhancements

Potential features for v2.0:
- [ ] Cloud sync (Firebase/Supabase)
- [ ] Push notifications for habit reminders
- [ ] Data export to CSV
- [ ] Custom habit icons
- [ ] Habit templates library
- [ ] Weekly/monthly reports
- [ ] Home screen widget
- [ ] Apple Health / Google Fit integration
- [ ] Social sharing
- [ ] Habit categories customization

## 🚢 Publishing to Google Play

### Before Publishing
1. Update `android/app/src/main/AndroidManifest.xml` with app name
2. Create app icon (512x512 PNG)
3. Generate signing key
4. Update `android/app/build.gradle` with signing config
5. Write actual Privacy Policy (replace placeholder)
6. Integrate AdMob (optional)
7. Test thoroughly on multiple devices

### Build Release
```bash
flutter build appbundle --release
```

Upload the generated `app-release.aab` to Google Play Console.

## 📄 License

This is a production-quality app template. Modify and publish as your own.

## 🤝 Contributing

This is a single-use template for publishing your own app. Feel free to fork and customize!

## 💬 Support

For questions about customization, see CUSTOMIZATION_GUIDE.md or the inline code comments.

## 🙏 Acknowledgments

- **Design Inspiration**: Modern wellness apps like Streaks, Fabulous
- **Color Palette**: Calming teal and coral for wellness aesthetic
- **Typography**: Inter font for clean readability
- **Icons**: Material Icons for consistency

---

**Built with Flutter 💙 | Ready for Production 🚀**
