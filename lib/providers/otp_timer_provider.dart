import 'dart:async';
import 'package:flutter/material.dart';

class OtpTimerProvider with ChangeNotifier {
  int _remainingTime = 0;
  Timer? _timer;
  bool _isTimerActive = false;

  int get remainingTime => _remainingTime;
  bool get isTimerActive => _isTimerActive;

  // Function to start the timer
  void startTimer(int duration) {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }

    _remainingTime = duration;
    _isTimerActive = true;
    notifyListeners(); // Notify UI to update

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        _remainingTime--;
        notifyListeners();
      } else {
        _timer?.cancel();
        _isTimerActive = false;
        notifyListeners();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _isTimerActive = false;
    notifyListeners();
  }
}
