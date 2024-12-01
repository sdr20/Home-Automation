import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../utils/snackbar_utils.dart';
import '../models/timer_state.dart';

class LEDService {
  static const String baseUrl = 'http://192.168.4.1';
  final List<TimerState> _timerStates = List.generate(
    4,
    (_) => TimerState(),
  );

  Future<void> controlLED(
    int id,
    bool state,
    BuildContext context,
    Function(bool) onStateChanged,
  ) async {
    final url = Uri.parse('$baseUrl/?id=$id&state=${state ? 1 : 0}');
    
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        onStateChanged(state);
        _handleTimerState(id, state);
        SnackbarUtils.showSuccess(
          context,
          'LED ${id + 1} turned ${state ? 'ON' : 'OFF'}',
          state,
        );
      } else {
        SnackbarUtils.showError(
          context,
          'Error: ${response.statusCode}',
        );
      }
    } catch (e) {
      SnackbarUtils.showError(
        context,
        'Failed to connect to ESP32: $e',
      );
    }
  }

  void _handleTimerState(int id, bool state) {
    if (!state) {
      _timerStates[id].durationTimer?.cancel();
      _timerStates[id].durationTimer = null;
    } else {
      _timerStates[id].activeDuration = 0;
      _timerStates[id].durationTimer = Timer.periodic(
        const Duration(seconds: 1),
        (_) {
          _timerStates[id].activeDuration++;
        },
      );
    }
  }

  void setTimer(
    int id,
    int hours,
    int minutes,
    int seconds,
    BuildContext context,
  ) {
    final totalSeconds = (hours * 3600) + (minutes * 60) + seconds;
    
    if (totalSeconds > 0) {
      _timerStates[id].offTimer?.cancel();
      _timerStates[id].offTimer = Timer(
        Duration(seconds: totalSeconds),
        () => controlLED(id, false, context, (_) {}),
      );
      
      SnackbarUtils.showInfo(
        context,
        'Timer set for LED ${id + 1}',
      );
    }
  }

  int getActiveDuration(int id) {
    return _timerStates[id].activeDuration;
  }

  void dispose() {
    for (var state in _timerStates) {
      state.dispose();
    }
  }
}