//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <xinlake_platform/xinlake_platform_plugin.h>
#include <xinlake_qrcode/xinlake_qrcode_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  XinlakePlatformPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("XinlakePlatformPlugin"));
  XinlakeQrcodePluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("XinlakeQrcodePlugin"));
}
