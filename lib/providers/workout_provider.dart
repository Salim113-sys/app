import 'package:daily_reset/models/workout_models.dart';
import 'package:daily_reset/services/workout_repository.dart';
import 'package:flutter/foundation.dart';

class WorkoutProvider extends ChangeNotifier {
  final WorkoutRepository _repository;

  WorkoutProvider(this._repository);

  List<WorkoutRoutine> get routines => _repository.routines;

  List<WorkoutStep> stepsForRoutine(String routineId) =>
      _repository.stepsForRoutine(routineId);

  List<WorkoutSessionLog> get logs => _repository.logs;

  Stream<List<WorkoutSessionLog>> get logsStream => _repository.logsStream;

  Future<void> addSessionLog(WorkoutSessionLog log) async {
    await _repository.addSessionLog(log);
    notifyListeners();
  }

  List<Map<String, dynamic>> getLast7DaysSummary() =>
      _repository.getLast7DaysSummary();

  (int totalMinutes, int activeDays) getLast7DaysTotals() =>
      _repository.getLast7DaysTotals();

  Future<void> clearAllData() async {
    await _repository.clearAllData();
    notifyListeners();
  }
}
