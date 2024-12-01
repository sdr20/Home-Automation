import 'dart:async';

class TimerState {
  Timer? offTimer;
  Timer? durationTimer;
  int activeDuration = 0;

  void dispose() {
    offTimer?.cancel();
    durationTimer?.cancel();
  }
}