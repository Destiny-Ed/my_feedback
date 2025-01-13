import 'package:flutter/material.dart';
import 'package:my_feedback/src/models/feedback_type.dart';
import 'package:my_feedback/src/provider/feedback_provider.dart';
import 'package:my_feedback/src/provider/recording_and_capture_provider.dart';
import 'package:my_feedback/src/provider/send_feedback_provider.dart';
import 'package:my_feedback/src/view/screenshot_and_draw.dart';
import 'package:my_feedback/src/view/send_feedback_page.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class FeedbackActionButton extends StatelessWidget {
  final FeedbackActionType feedbackType;
  final ScreenshotController screenshotController;

  const FeedbackActionButton({
    super.key,
    required this.feedbackType,
    required this.screenshotController,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<RecordingProvider>(
          builder: (context, recordingProvider, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (feedbackType == FeedbackActionType.screenshot) _buildScreenshotButton(context),
                if (feedbackType == FeedbackActionType.recording) ..._buildRecordingButtons(context, recordingProvider),
                const SizedBox(height: 16),
                _buildCancelButton(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildScreenshotButton(BuildContext context) {
    return FloatingActionButton(
      mini: true,
      heroTag: 'feedbackCaptureButton',
      onPressed: () async {
        final capturedImage = await screenshotController.capture();
        if (capturedImage != null && context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScreenshotAndDrawScreen(capturedImage: capturedImage),
            ),
          );
        }
      },
      child: const Icon(Icons.camera),
    );
  }

  List<Widget> _buildRecordingButtons(BuildContext context, RecordingProvider recordingProvider) {
    final List<Widget> buttons = [];

    if (!recordingProvider.isRecording) {
      buttons.add(
        FloatingActionButton(
          mini: true,
          heroTag: 'feedbackRecordPlayButton',
          onPressed: () async {
            final result = await recordingProvider.startRecording();
            if (result.status && context.mounted) {
              _navigateToSendFeedbackPage(context, result.path);
            }
          },
          child: const Icon(Icons.play_arrow),
        ),
      );
    } else {
      buttons.add(
        FloatingActionButton(
          mini: true,
          heroTag: 'feedbackRecordStopButton',
          onPressed: () async {
            final result = await recordingProvider.stopRecording();
            if (result.status && context.mounted) {
              _navigateToSendFeedbackPage(context, result.path);
            }
          },
          child: const Icon(Icons.stop),
        ),
      );
    }

    buttons.add(
      FloatingActionButton(
        mini: true,
        heroTag: 'feedbackRecordDurationButton',
        backgroundColor: recordingProvider.isRecording ? Colors.red : null,
        onPressed: null,
        child: Text(
          recordingProvider.formattedDuration,
          style: const TextStyle(fontSize: 10),
        ),
      ),
    );

    return buttons;
  }

  Widget _buildCancelButton(BuildContext context) {
    return FloatingActionButton(
      mini: true,
      heroTag: 'feedbackCancelButton',
      onPressed: () {
        final feedbackTypeProvider = context.read<FeedbackProvider>();
        if (feedbackTypeProvider.feedbackType == FeedbackActionType.recording) {
          context.read<RecordingProvider>().stopRecording();
        }
        feedbackTypeProvider.setFeedbackActionType(FeedbackActionType.none);
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (context) => const SendFeedbackPage()),
        );
      },
      child: const Icon(Icons.cancel),
    );
  }

  void _navigateToSendFeedbackPage(BuildContext context, String path) {
    context.read<SendFeedbackProvider>().addImage(UploadedMediaModel(mediaPath: path, mediaType: MediaType.video));
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SendFeedbackPage()),
      ModalRoute.withName('/'),
    );
  }
}
