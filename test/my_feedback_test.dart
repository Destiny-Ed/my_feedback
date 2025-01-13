// import 'package:flutter_test/flutter_test.dart';
// import 'package:my_feedback/my_feedback.dart';
// import 'package:my_feedback/my_feedback_platform_interface.dart';
// import 'package:my_feedback/my_feedback_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockMyFeedbackPlatform
//     with MockPlatformInterfaceMixin
//     implements MyFeedbackPlatform {

//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final MyFeedbackPlatform initialPlatform = MyFeedbackPlatform.instance;

//   test('$MethodChannelMyFeedback is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelMyFeedback>());
//   });

//   test('getPlatformVersion', () async {
//     MyFeedback myFeedbackPlugin = MyFeedback();
//     MockMyFeedbackPlatform fakePlatform = MockMyFeedbackPlatform();
//     MyFeedbackPlatform.instance = fakePlatform;

//     expect(await myFeedbackPlugin.getPlatformVersion(), '42');
//   });
// }
