#ifndef FLUTTER_PLUGIN_FLUTTER_CCID_PLUGIN_H_
#define FLUTTER_PLUGIN_FLUTTER_CCID_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace flutter_ccid {

class FlutterCcidPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FlutterCcidPlugin();

  virtual ~FlutterCcidPlugin();

  // Disallow copy and assign.
  FlutterCcidPlugin(const FlutterCcidPlugin&) = delete;
  FlutterCcidPlugin& operator=(const FlutterCcidPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace flutter_ccid

#endif  // FLUTTER_PLUGIN_FLUTTER_CCID_PLUGIN_H_
