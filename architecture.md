# Daily Reset – Micro Habits & Mood Architecture

## Overview
A production-quality mobile app for tracking micro-habits and mood, helping busy people reset daily with calm, focus, and control.

## Technical Stack
- **Framework**: Flutter 3.6+
- **State Management**: Provider
- **Storage**: shared_preferences (persistent local storage)
- **Navigation**: go_router
- **Design**: Custom modern UI with generous spacing and elegant fonts

## Data Models

### 1. Habit Model (`lib/models/habit.dart`)
- `id: String` (UUID)
- `name: String` (required)
- `description: String?` (optional)
- `category: HabitCategory` (Body/Mind/Focus/Life)
- `targetDaysPerWeek: int` (1-7)
- `createdAt: DateTime`
- `updatedAt: DateTime`

### 2. DailyLog Model (`lib/models/daily_log.dart`)
- `id: String` (UUID)
- `date: DateTime` (normalized to start of day)
- `mood: MoodLevel` (VeryLow, Low, Neutral, Good, VeryGood)
- `completedHabitIds: List<String>`
- `createdAt: DateTime`
- `updatedAt: DateTime`

### 3. Enums
- `HabitCategory`: Body, Mind, Focus, Life
- `MoodLevel`: VeryLow, Low, Neutral, Good, VeryGood

## Service Layer

### 1. StorageService (`lib/services/storage_service.dart`)
- Wraps shared_preferences for persistent storage
- Key-value store with JSON serialization
- Initialize on app start

### 2. HabitService (`lib/services/habit_service.dart`)
- CRUD operations for habits
- Validation (name required, target days 1-7)
- Local storage persistence
- Sample data for new users

### 3. DailyLogService (`lib/services/daily_log_service.dart`)
- CRUD operations for daily logs
- Track mood and habit completions
- Get logs by date range
- Calculate streaks and statistics
- Sample data for demonstration

## State Management (Provider)

### 1. ThemeProvider (`lib/providers/theme_provider.dart`)
- Toggle light/dark mode
- Persist theme preference
- Notify listeners on change

### 2. HabitProvider (`lib/providers/habit_provider.dart`)
- Manage habit state
- CRUD operations via HabitService
- Notify UI on changes

### 3. DailyLogProvider (`lib/providers/daily_log_provider.dart`)
- Manage daily log state
- Track today's mood and completions
- Calculate streaks and stats
- Notify UI on changes

## Screen Structure

### 1. Onboarding Flow (`lib/screens/onboarding/`)
- `onboarding_screen.dart`: PageView with 3 pages
  - Page 1: Track tiny habits
  - Page 2: Log your mood daily
  - Page 3: See your progress
  - "Get Started" button → Home

### 2. Main App (`lib/screens/`)
- Bottom navigation with 3 tabs: Home, Stats, Settings
- Floating action button on Home to manage habits

#### Home Screen (`home_screen.dart`)
- Today's date and friendly greeting
- Mood selector (5 emoji buttons)
- List of today's habits with checkboxes
- Motivational quote at bottom
- Access to Habits Management via FAB

#### Stats Screen (`stats_screen.dart`)
- Habit streaks (days in a row)
- Weekly completion percentage (last 7 days)
- Mood trend for last 7 days (visual indicators)
- AdMob integration point (banner at bottom)

#### Settings Screen (`settings_screen.dart`)
- Light/Dark mode toggle
- Reset all data button (with confirmation)
- Privacy Policy link
- AdMob integration point (banner at bottom)

### 3. Habits Management (`lib/screens/habits/`)
- `habits_list_screen.dart`: View all habits
- `habit_form_screen.dart`: Add/Edit habit with validation

### 4. Privacy Policy (`lib/screens/privacy_policy_screen.dart`)
- Placeholder text for later replacement

## UI Components (`lib/widgets/`)

### Reusable Widgets
- `mood_selector.dart`: 5-emoji mood picker
- `habit_card.dart`: Display single habit with checkbox
- `stat_card.dart`: Display stat with icon and value
- `mood_trend_chart.dart`: Simple visual mood trend
- `custom_button.dart`: Styled button component
- `empty_state.dart`: Friendly empty state messages

## Navigation (`lib/router.dart`)
- `/`: Onboarding (first launch) or Home
- `/home`: Main app with bottom nav
- `/habits`: Habits list
- `/habits/add`: Add habit
- `/habits/edit/:id`: Edit habit
- `/privacy`: Privacy policy

## Theme & Design (`lib/theme.dart`)

### Color Palette (Modern & Calming)
- **Primary**: Soft teal/blue-green (#4ECDC4) - calm, reset vibes
- **Secondary**: Warm coral (#FF6B6B) - energy, motivation
- **Success**: Gentle green (#95E1D3) - progress, achievement
- **Background**: 
  - Light: Soft cream (#FAFAF9)
  - Dark: Deep navy (#1A1F2E)
- **Surface cards**: Elevated with subtle shadows

### Typography
- **Heading**: Plus Jakarta Sans (elegant, modern)
- **Body**: Inter (clean, readable)
- Generous spacing: 16-24px between sections

### Design Principles
- Rounded corners (16-20px)
- Soft shadows (no harsh Material elevation)
- Ample padding (20-24px)
- Smooth animations for interactions
- Emoji-forward (mood, categories)

## Implementation Steps

1. **Setup** ✓
   - Update pubspec.yaml dependencies
   - Configure theme colors and fonts
   - Set up navigation structure

2. **Data Layer**
   - Create models with validation
   - Implement storage service
   - Build habit and daily log services with sample data

3. **State Management**
   - Create providers for theme, habits, logs
   - Initialize providers in main.dart

4. **Onboarding**
   - Build 3-page onboarding with illustrations
   - Implement first-launch detection
   - Navigation to home

5. **Home Screen**
   - Date and greeting
   - Mood selector integration
   - Habits list with completions
   - Quote display

6. **Habits Management**
   - List all habits
   - Add/Edit forms with validation
   - Delete with confirmation
   - Category selection

7. **Stats Screen**
   - Calculate streaks
   - Weekly completion %
   - Mood trend visualization
   - AdMob placeholder

8. **Settings Screen**
   - Theme toggle
   - Reset data confirmation
   - Privacy policy link
   - AdMob placeholder

9. **Polish**
   - Animations and transitions
   - Empty states
   - Error handling
   - Loading states

10. **Testing & Debugging**
    - Run compile_project
    - Fix all errors
    - Verify data persistence

## AdMob Integration Points

### Where to Add Banners (Future)
1. **Stats Screen**: Bottom banner (non-intrusive)
2. **Settings Screen**: Bottom banner
3. **NOT on Home**: Keep daily interaction ad-free

### Implementation Notes
- Add `google_mobile_ads` package
- Initialize in main.dart
- Use BannerAdWidget component
- Test with demo ad units first
- Follow Google AdMob policies

## Customization Guide

### App Name
- `pubspec.yaml`: Update `name` and `description`
- `android/app/src/main/AndroidManifest.xml`: Update `android:label`
- `ios/Runner/Info.plist`: Update `CFBundleDisplayName`

### Colors
- `lib/theme.dart`: Modify color constants in theme classes
- Update both light and dark mode palettes

### Fonts
- `lib/theme.dart`: Change GoogleFonts in `_buildTextTheme`
- Or add custom fonts to `assets/fonts/` and update pubspec

## Future Enhancements
- Cloud sync (Firebase/Supabase)
- Habit reminders/notifications
- Custom habit icons
- Social sharing
- Export data to CSV
- Habit templates library
