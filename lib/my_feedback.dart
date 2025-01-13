
import 'my_feedback_platform_interface.dart';

class MyFeedback {
  Future<String?> getPlatformVersion() {
    return MyFeedbackPlatform.instance.getPlatformVersion();
  }
}
