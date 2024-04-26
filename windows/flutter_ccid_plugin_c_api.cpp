#include "include/flutter_ccid/flutter_ccid_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_ccid_plugin.h"

void FlutterCcidPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_ccid::FlutterCcidPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
