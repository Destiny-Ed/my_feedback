#include "include/my_feedback/my_feedback_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "my_feedback_plugin.h"

void MyFeedbackPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  my_feedback::MyFeedbackPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
