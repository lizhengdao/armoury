#include "include/window_interface/window_interface_plugin.h"

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

/* full screen
 */
extern void getFullScreen(const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

extern void setFullScreen(const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

extern void toggleFullScreen(const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

/* window placement
 */
extern void getWindowPlacement(const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

extern void setWindowPlacement(const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

/* min size
 */
extern void getWindowMinSize(const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

extern void setWindowMinSize(const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

extern void resetWindowMinSize(const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

/* max size
 */
extern void getWindowMaxSize(const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

extern void setWindowMaxSize(const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

extern void resetWindowMaxSize(const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

/* stay on top
 */
extern void setStayOnTop(const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

extern void init();

namespace Armoury {
    class WindowInterfacePlugin : public flutter::Plugin {
    public:
        static void RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar);

        WindowInterfacePlugin();
        virtual ~WindowInterfacePlugin();

    private:
        // Called when a method is called on this plugin's channel from Dart.
        void HandleMethodCall(const flutter::MethodCall<flutter::EncodableValue>& method_call,
            std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    };

    // static
    void WindowInterfacePlugin::RegisterWithRegistrar(
        flutter::PluginRegistrarWindows* registrar) {
        auto channel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
            registrar->messenger(), "window_interface",
            &flutter::StandardMethodCodec::GetInstance());

        auto plugin = std::make_unique<WindowInterfacePlugin>();

        channel->SetMethodCallHandler(
            [plugin_pointer = plugin.get()](const auto& call, auto result) {
            plugin_pointer->HandleMethodCall(call, std::move(result));
        });

        registrar->AddPlugin(std::move(plugin));

        // init window placement
        init();
    }

    WindowInterfacePlugin::WindowInterfacePlugin() {}
    WindowInterfacePlugin::~WindowInterfacePlugin() {}

    void WindowInterfacePlugin::HandleMethodCall(
        const flutter::MethodCall<flutter::EncodableValue>& method_call,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

        const std::string method_name = method_call.method_name();
        if (method_name == "getFullScreen") {
            getFullScreen(method_call, std::move(result));
        } else if (method_name == "setFullScreen") {
            setFullScreen(method_call, std::move(result));
        } else if (method_name == "toggleFullScreen") {
            toggleFullScreen(method_call, std::move(result));
        } else if (method_name == "getWindowPlacement") {
            getWindowPlacement(method_call, std::move(result));
        } else if (method_name == "setWindowPlacement") {
            setWindowPlacement(method_call, std::move(result));
        } else if (method_name == "getWindowMinSize") {
            getWindowMinSize(method_call, std::move(result));
        } else if (method_name == "setWindowMinSize") {
            setWindowMinSize(method_call, std::move(result));
        } else if (method_name == "resetWindowMinSize") {
            resetWindowMinSize(method_call, std::move(result));
        } else if (method_name == "getWindowMaxSize") {
            getWindowMaxSize(method_call, std::move(result));
        } else if (method_name == "setWindowMaxSize") {
            setWindowMaxSize(method_call, std::move(result));
        } else if (method_name == "resetWindowMaxSize") {
            resetWindowMaxSize(method_call, std::move(result));
        } else if (method_name == "setStayOnTop") {
            setStayOnTop(method_call, std::move(result));
        } else {
            result->NotImplemented();
        }
    }
}  // namespace 


void WindowInterfacePluginRegisterWithRegistrar(FlutterDesktopPluginRegistrarRef registrar) {
    Armoury::WindowInterfacePlugin::RegisterWithRegistrar(
        flutter::PluginRegistrarManager::GetInstance()
        ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
