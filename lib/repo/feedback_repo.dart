import 'package:flutter/material.dart';
import 'package:my_feedback/models/feedback_type.dart';

abstract class FeedbackRepo {
  Future<void> showFeedBackWithResult(BuildContext context,
      {required String userId, required Function(FeedbackMediaResultModel?) onResult});
}
