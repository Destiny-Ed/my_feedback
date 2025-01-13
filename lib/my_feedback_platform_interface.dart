import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'my_feedback_method_channel.dart';

abstract class MyFeedbackPlatform extends PlatformInterface {
  /// Constructs a MyFeedbackPlatform.
  MyFeedbackPlatform() : super(token: _token);

  static final Object _token = Object();

  static MyFeedbackPlatform _instance = MethodChannelMyFeedback();

  /// The default instance of [MyFeedbackPlatform] to use.
  ///
  /// Defaults to [MethodChannelMyFeedback].
  static MyFeedbackPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MyFeedbackPlatform] when
  /// they register themselves.
  static set instance(MyFeedbackPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
