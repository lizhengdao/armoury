#include "include/xinlake_qrcode/xinlake_qrcode_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <map>
#include <memory>
#include <sstream>

extern void fromImage(const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    
namespace {
    class XinlakeQrcodePlugin : public flutter::Plugin {
    public:
        static void RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar);

        XinlakeQrcodePlugin();
        virtual ~XinlakeQrcodePlugin();

    private:
        // Called when a method is called on this plugin's channel from Dart.
        void HandleMethodCall(
            const flutter::MethodCall<flutter::EncodableValue>& method_call,
            std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    };

    // static
    void XinlakeQrcodePlugin::RegisterWithRegistrar(
        flutter::PluginRegistrarWindows* registrar) {
        auto channel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
            registrar->messenger(), "xinlake_qrcode",
            &flutter::StandardMethodCodec::GetInstance());

        auto plugin = std::make_unique<XinlakeQrcodePlugin>();

        channel->SetMethodCallHandler(
            [plugin_pointer = plugin.get()](const auto& call, auto result) {
            plugin_pointer->HandleMethodCall(call, std::move(result));
        });

        registrar->AddPlugin(std::move(plugin));
    }

    XinlakeQrcodePlugin::XinlakeQrcodePlugin() {}
    XinlakeQrcodePlugin::~XinlakeQrcodePlugin() {}

    void XinlakeQrcodePlugin::HandleMethodCall(
        const flutter::MethodCall<flutter::EncodableValue>& method_call,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

        const std::string method_name = method_call.method_name();

        if (method_name == "fromImage") {
            fromImage(method_call, std::move(result));
        } else {
            result->NotImplemented();
        }
    }
}  // namespace

void XinlakeQrcodePluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
    XinlakeQrcodePlugin::RegisterWithRegistrar(
        flutter::PluginRegistrarManager::GetInstance()
        ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
