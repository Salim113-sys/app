import 'dart:async';
import 'package:flutter/foundation.dart';

enum FocusState { idle, running, paused, completed }

class FocusProvider extends ChangeNotifier {
  Timer? _timer;
  int _remainingSeconds = 0;
  int _initialDuration = 0;
  FocusState _state = FocusState.idle;

  FocusState get state => _state;
  int get remainingSeconds => _remainingSeconds;
  double get progress => _initialDuration == 0 ? 0 : 1 - (_remainingSeconds / _initialDuration);

  void startSession(int minutes) {
    if (_state == FocusState.running) return;
    
    _state = FocusState.running;
    _initialDuration = minutes * 60;
    _remainingSeconds = _initialDuration;
    notifyListeners();
    
    _startTimer();
  }

  void pause() {
    if (_state != FocusState.running) return;
    _state = FocusState.paused;
    _timer?.cancel();
    notifyListeners();
  }

  void resume() {
    if (_state != FocusState.paused) return;
    _state = FocusState.running;
    _startTimer();
    notifyListeners();
  }

  void stop() {
    _timer?.cancel();
    _state = FocusState.idle;
    _remainingSeconds = 0;
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _completeSession();
      }
    });
  }

  void _completeSession() {
    _timer?.cancel();
    _state = FocusState.completed;
    notifyListeners();
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
