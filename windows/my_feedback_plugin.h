#ifndef FLUTTER_PLUGIN_MY_FEEDBACK_PLUGIN_H_
#define FLUTTER_PLUGIN_MY_FEEDBACK_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace my_feedback {

class MyFeedbackPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  MyFeedbackPlugin();

  virtual ~MyFeedbackPlugin();

  // Disallow copy and assign.
  MyFeedbackPlugin(const MyFeedbackPlugin&) = delete;
  MyFeedbackPlugin& operator=(const MyFeedbackPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace my_feedback

#endif  // FLUTTER_PLUGIN_MY_FEEDBACK_PLUGIN_H_
