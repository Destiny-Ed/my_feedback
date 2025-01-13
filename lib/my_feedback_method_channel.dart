import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'my_feedback_platform_interface.dart';

/// An implementation of [MyFeedbackPlatform] that uses method channels.
class MethodChannelMyFeedback extends MyFeedbackPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('my_feedback');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
