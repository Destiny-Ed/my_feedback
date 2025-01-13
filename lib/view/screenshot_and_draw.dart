import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:my_feedback/models/feedback_type.dart';
import 'package:my_feedback/provider/send_feedback_provider.dart';
import 'package:my_feedback/view/send_feedback_page.dart';
import 'package:provider/provider.dart';
import 'package:painter/painter.dart';
import 'package:screenshot/screenshot.dart';

class ScreenshotAndDrawScreen extends StatefulWidget {
  final Uint8List? capturedImage;

  const ScreenshotAndDrawScreen({super.key, required this.capturedImage});

  @override
  _ScreenshotAndDrawScreenState createState() => _ScreenshotAndDrawScreenState();
}

class _ScreenshotAndDrawScreenState extends State<ScreenshotAndDrawScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  final PainterController _painterController = _initializePainterController();

  List<Color> drawColors = [Colors.black, Colors.red, Colors.white, Colors.blue, Colors.yellow];

  static PainterController _initializePainterController() {
    PainterController controller = PainterController();
    controller.thickness = 5.0;
    controller.backgroundColor = Colors.transparent;
    controller.drawColor = Colors.black;
    return controller;
  }

  Future<void> _saveDrawing() async {
    try {
      final screenshotResult = await _screenshotController.capture();
      if (screenshotResult != null && mounted) {
        context.read<SendFeedbackProvider>().addImage(
              UploadedMediaModel(mediaPath: screenshotResult, mediaType: MediaType.screenshot),
            );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SendFeedbackPage()),
          ModalRoute.withName('/'),
        );
      } else {
        log("Failed to capture screenshot.");
      }
    } catch (e) {
      log("Screenshot capture error: $e");
    }
  }

  void _undoDrawing() {
    if (!_painterController.isEmpty) {
      _painterController.undo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Draw on Screenshot"),
        actions: [
          IconButton(
            onPressed: _undoDrawing,
            icon: const Icon(Icons.restart_alt),
          ),
          IconButton(
            onPressed: _saveDrawing,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildColorPicker(),
          const SizedBox(height: 20),
          Expanded(
            child: widget.capturedImage == null
                ? const Center(child: Text("Capture a screenshot to draw"))
                : Screenshot(
                    controller: _screenshotController,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.memory(widget.capturedImage!),
                        Painter(_painterController),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorPicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(drawColors.length, (index) {
        final color = drawColors[index];
        return GestureDetector(
          onTap: () => _painterController.drawColor = color,
          child: CircleAvatar(
            backgroundColor: color,
          ),
        );
      }),
    );
  }
}
