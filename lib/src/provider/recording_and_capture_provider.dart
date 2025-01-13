import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screen_recording/flutter_screen_recording.dart';
import 'package:my_feedback/src/models/recording_result.dart';

class RecordingProvider extends ChangeNotifier {
  bool _isRecording = false;
  int _recordingDuration = 0;
  final int _maxDuration = 60; // Max duration set to 1 minute
  Timer? _timer;

  bool get isRecording => _isRecording;
  int get recordingDuration => _recordingDuration;

  // Starts screen recording and updates the recording state
  Future<RecordingResult> startRecording() async {
    RecordingResult result = RecordingResult();
    try {
      final randomId = math.Random().nextInt(400);
      final isStarted = await FlutterScreenRecording.startRecordScreenAndAudio(
        "my_feedback_record_$randomId",
      );

      if (!isStarted) {
        return RecordingResult();
      }

      _isRecording = true;
      _recordingDuration = 0;
      notifyListeners();

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        _recordingDuration++;
        notifyListeners();

        if (_recordingDuration >= _maxDuration) {
          result = await stopRecording();
        }
      });

      return result;
    } catch (e) {
      log("Error starting recording: $e");
      return RecordingResult();
    }
  }

  // Stops the recording and resets the state
  Future<RecordingResult> stopRecording() async {
    try {
      _timer?.cancel();
      final path = await FlutterScreenRecording.stopRecordScreen;
      _isRecording = false;
      _recordingDuration = 0;
      notifyListeners();

      log("Screen recording saved to: $path");
      return RecordingResult(path: path, status: true);
    } catch (e) {
      log("Error stopping recording: $e");
      return RecordingResult();
    }
  }

  // Formats duration to MM:SS format
  String get formattedDuration {
    final minutes = _recordingDuration ~/ 60;
    final seconds = _recordingDuration % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
