import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:daily_reset/screens/onboarding_screen.dart';
import 'package:daily_reset/screens/main_app_screen.dart';
import 'package:daily_reset/screens/habits_list_screen.dart';
import 'package:daily_reset/screens/habit_form_screen.dart';
import 'package:daily_reset/screens/privacy_policy_screen.dart';
import 'package:daily_reset/screens/program_detail_screen.dart';
import 'package:daily_reset/screens/workout_routine_detail_screen.dart';
import 'package:daily_reset/screens/workout_session_screen.dart';
import 'package:daily_reset/screens/focus_screen.dart';
import 'package:daily_reset/screens/breathing_screen.dart';
import 'package:daily_reset/models/program_pack.dart';
import 'package:daily_reset/services/storage_service.dart';

class AppRouter {
  static Future<bool> _hasCompletedOnboarding() async {
    final storage = await StorageService.getInstance();
    return storage.getBool('onboarding_completed') ?? false;
  }

  static GoRouter get router => GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) async {
          final hasCompleted = await _hasCompletedOnboarding();
          return hasCompleted ? '/home' : '/onboarding';
        },
      ),
      GoRoute(
        path: '/onboarding',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const MainAppScreen(),
        ),
      ),
      GoRoute(
        path: '/habits',
        pageBuilder: (context, state) => MaterialPage(
          child: const HabitsListScreen(),
        ),
      ),
      GoRoute(
        path: '/habits/add',
        pageBuilder: (context, state) {
          final programId = state.uri.queryParameters['programId'];
          return MaterialPage(
            child: HabitFormScreen(programId: programId),
          );
        },
      ),
      GoRoute(
        path: '/habits/edit/:id',
        pageBuilder: (context, state) => MaterialPage(
          child: HabitFormScreen(
            habitId: state.pathParameters['id'],
          ),
        ),
      ),
      GoRoute(
        path: '/privacy',
        pageBuilder: (context, state) => MaterialPage(
          child: const PrivacyPolicyScreen(),
        ),
      ),
      GoRoute(
        path: '/programs/:id',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'];
          final pack = ProgramPacksRepository.defaultPacks.firstWhere(
            (p) => p.id == id,
            orElse: () => ProgramPacksRepository.defaultPacks.first,
          );

          return MaterialPage(
            child: ProgramDetailScreen(pack: pack),
          );
        },
      ),
      GoRoute(
        path: '/workout/routines/:id',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return MaterialPage(
            child: WorkoutRoutineDetailScreen(routineId: id),
          );
        },
      ),
      GoRoute(
        path: '/workout/session/:id',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return MaterialPage(
            child: WorkoutSessionScreen(routineId: id),
          );
        },
      ),
      GoRoute(
        path: '/focus',
        pageBuilder: (context, state) => MaterialPage(
          child: const FocusScreen(),
        ),
      ),
      GoRoute(
        path: '/breathing',
        pageBuilder: (context, state) => MaterialPage(
          child: const BreathingScreen(),
        ),
      ),
    ],
  );
}
