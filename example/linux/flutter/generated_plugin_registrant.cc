//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <ccid/ccid_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) ccid_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "CcidPlugin");
  ccid_plugin_register_with_registrar(ccid_registrar);
}
