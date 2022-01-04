#include "include/xinlake_platform/xinlake_platform_plugin.h"

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

extern void getAppVersion(const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

extern void getAppDir(const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

extern void pickFiles(const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

namespace {
    class XinlakePlatformPlugin : public flutter::Plugin {
    public:
        static void RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar);

        XinlakePlatformPlugin();
        virtual ~XinlakePlatformPlugin();

    private:
        // Called when a method is called on this plugin's channel from Dart.
        void HandleMethodCall(const flutter::MethodCall<flutter::EncodableValue>& method_call,
            std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    };

    // static
    void XinlakePlatformPlugin::RegisterWithRegistrar(
        flutter::PluginRegistrarWindows* registrar) {
        auto channel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
            registrar->messenger(), "xinlake_platform",
            &flutter::StandardMethodCodec::GetInstance());

        auto plugin = std::make_unique<XinlakePlatformPlugin>();

        channel->SetMethodCallHandler(
            [plugin_pointer = plugin.get()](const auto& call, auto result) {
            plugin_pointer->HandleMethodCall(call, std::move(result));
        });

        registrar->AddPlugin(std::move(plugin));
    }

    XinlakePlatformPlugin::XinlakePlatformPlugin() {}
    XinlakePlatformPlugin::~XinlakePlatformPlugin() {}

    void XinlakePlatformPlugin::HandleMethodCall(
        const flutter::MethodCall<flutter::EncodableValue>& method_call,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

        const std::string method_name = method_call.method_name();

        if (method_name == "getPlatformVersion") {
            std::ostringstream version_stream;
            version_stream << "Windows ";
            if (IsWindows10OrGreater()) {
                version_stream << "10+";
            } else if (IsWindows8OrGreater()) {
                version_stream << "8";
            } else if (IsWindows7OrGreater()) {
                version_stream << "7";
            }
            result->Success(flutter::EncodableValue(version_stream.str()));
        } else if (method_name == "getAppVersion") {
            getAppVersion(method_call, std::move(result));
        } else if (method_name == "getAppDir") {
            getAppDir(method_call, std::move(result));
        } else if (method_name == "pickFiles") {
            pickFiles(method_call, std::move(result));
        } else {
            result->NotImplemented();
        }
    }
}  // namespace

void XinlakePlatformPluginRegisterWithRegistrar(FlutterDesktopPluginRegistrarRef registrar) {
    XinlakePlatformPlugin::RegisterWithRegistrar(
        flutter::PluginRegistrarManager::GetInstance()
        ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
