import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_feedback/models/feedback_type.dart';
import 'package:my_feedback/provider/send_feedback_provider.dart';
import 'package:my_feedback/repo/feedback_repo.dart';
import 'package:my_feedback/view/feedback_dialog.dart';
import 'package:provider/provider.dart';

class FeedbackProvider extends ChangeNotifier implements FeedbackRepo {
  late Completer<void> _feedbackCompleter;

  // Holds the current feedback action type
  FeedbackActionType _feedbackType = FeedbackActionType.none;
  FeedbackActionType get feedbackType => _feedbackType;

  // Set the current feedback action type and notify listeners
  setFeedbackActionType(FeedbackActionType type) {
    _feedbackType = type;
    notifyListeners();
  }

  // Stores the feedback media result
  FeedbackMediaResultModel? _feedbackResult;

  // Set the feedback result and notify listeners
  setFeedbackResult(FeedbackMediaResultModel? result) {
    _feedbackResult = result;
    notifyListeners();

    // If there's a pending completer, complete it
    if (!_feedbackCompleter.isCompleted) {
      _feedbackCompleter.complete();
    }
  }

  @override
  Future<void> showFeedBackWithResult(BuildContext context,
      {required String userId, required Function(FeedbackMediaResultModel?) onResult}) async {
    ///Set feedback user Id
    context.read<SendFeedbackProvider>().userIdEmail = userId;

    // Show feedback dialog
    showFeedbackModel(context);

    // Initialize a new completer to track this feedback session
    _feedbackCompleter = Completer<void>();

    try {
      // Wait for the feedback result to be set
      await _feedbackCompleter.future;

      // Return the result to the callback
      onResult(_feedbackResult);
    } catch (e) {
      // Handle any unexpected error here
      debugPrint("Error in feedback process: $e");
      onResult(null); // Or handle error as necessary
    }
  }
}
