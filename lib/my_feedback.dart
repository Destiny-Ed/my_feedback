// import 'my_feedback_platform_interface.dart';

// class MyFeedback {
//   Future<String?> getPlatformVersion() {
//     return MyFeedbackPlatform.instance.getPlatformVersion();
//   }
// }

import 'package:flutter/material.dart';
import 'package:my_feedback/src/models/feedback_type.dart';
import 'package:my_feedback/src/provider/feedback_provider.dart';
import 'package:my_feedback/src/provider/recording_and_capture_provider.dart';
import 'package:my_feedback/src/provider/send_feedback_provider.dart';
import 'package:my_feedback/src/view/feedback_action_button.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class MyFeedback extends StatefulWidget {
  final Widget child;
  // final String apiToken;
  const MyFeedback({
    super.key,
    required this.child,
    //  required this.apiToken
  });

  @override
  State<MyFeedback> createState() => _MyFeedbackState();
}

class _MyFeedbackState extends State<MyFeedback> {
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return _buildProviders(
      child: MaterialApp(
        home: Stack(
          children: [
            // Main content wrapped in Screenshot controller
            Screenshot(
              controller: _screenshotController,
              child: widget.child,
            ),
            // Display FeedbackActionButton based on feedback type
            _buildFeedbackAction(),
          ],
        ),
      ),
    );
  }

  /// Sets up the necessary providers for feedback functionality.
  Widget _buildProviders({required Widget child}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FeedbackProvider()),
        ChangeNotifierProvider(create: (_) => SendFeedbackProvider()),
        ChangeNotifierProvider(create: (_) => RecordingProvider()),
      ],
      child: child,
    );
  }

  /// Conditionally displays the [FeedbackActionButton] based on feedback type.
  Widget _buildFeedbackAction() {
    final feedbackState = context.watch<FeedbackProvider>();
    return (feedbackState.feedbackType != FeedbackActionType.none &&
            feedbackState.feedbackType != FeedbackActionType.file)
        ? FeedbackActionButton(
            feedbackType: feedbackState.feedbackType,
            screenshotController: _screenshotController,
          )
        : const SizedBox.shrink();
  }
}
