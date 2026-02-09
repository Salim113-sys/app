import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daily_reset/router.dart';
import 'package:daily_reset/services/storage_service.dart';
import 'package:daily_reset/services/habit_service.dart';
import 'package:daily_reset/services/daily_log_service.dart';
import 'package:daily_reset/services/hydration_repository.dart';
import 'package:daily_reset/providers/theme_provider.dart';
import 'package:daily_reset/providers/habit_provider.dart';
import 'package:daily_reset/providers/daily_log_provider.dart';
import 'package:daily_reset/providers/hydration_provider.dart';
import 'package:daily_reset/services/notification_service.dart';
import 'package:daily_reset/services/workout_repository.dart';
import 'package:daily_reset/providers/workout_provider.dart';
import 'package:daily_reset/providers/streak_provider.dart';
import 'package:daily_reset/providers/focus_provider.dart';
import 'package:daily_reset/screens/main_app_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final storage = await StorageService.getInstance();
  final habitService = HabitService(storage);
  final dailyLogService = DailyLogService(storage);
  final notificationService = NotificationService();
  await notificationService.init();
  final workoutRepository = await WorkoutRepository.create();
  
  runApp(MyApp(
    storage: storage,
    habitService: habitService,
    dailyLogService: dailyLogService,
    notificationService: notificationService,
    workoutRepository: workoutRepository,
  ));
}

class MyApp extends StatelessWidget {
  final StorageService storage;
  final HabitService habitService;
  final DailyLogService dailyLogService;
  final NotificationService notificationService;
  final WorkoutRepository workoutRepository;

  const MyApp({
    super.key,
    required this.storage,
    required this.habitService,
    required this.dailyLogService,
    required this.notificationService,
    required this.workoutRepository,
  });

  @override
  Widget build(BuildContext context) {
     return MultiProvider(
       providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider(storage)),
         ChangeNotifierProvider(create: (_) => MainNavigationState()),
          Provider<NotificationService>.value(value: notificationService),
          ChangeNotifierProvider(create: (_) => HabitProvider(habitService, notificationService)),
          ChangeNotifierProvider(create: (_) => DailyLogProvider(dailyLogService)),
          ChangeNotifierProxyProvider<DailyLogProvider, StreakProvider>(
            create: (context) => StreakProvider(Provider.of<DailyLogProvider>(context, listen: false)),
            update: (context, logProvider, streakProvider) => streakProvider!,
          ),
           ChangeNotifierProvider(
            create: (_) => HydrationProvider(
              HydrationRepository(storage),
              notificationService,
            ),
          ),
          ChangeNotifierProvider(
            create: (_) => WorkoutProvider(workoutRepository),
          ),
          ChangeNotifierProvider(create: (_) => FocusProvider()),
       ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp.router(
            title: 'Daily Reset',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.themeData,
            themeMode: ThemeMode.light, // We manage theme manually via themeData
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
