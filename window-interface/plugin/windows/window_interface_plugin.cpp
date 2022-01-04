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


namespace Armoury {
    WNDPROC defWindowProc;

    int maxWidth = 0;
    int maxHeight = 0;
    int minWidth = 0;
    int minHeight = 0;

    // active size settings
    void updateWindowSize() {
        RECT rect;
        HWND handle = GetActiveWindow();
        GetWindowRect(handle, &rect);
        MoveWindow(handle, rect.left, rect.top, rect.right - rect.left, rect.bottom - rect.top, FALSE);
    }

    void getWindowSize(const flutter::MethodCall<flutter::EncodableValue>& method_call,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
        HWND handle = GetActiveWindow();

        RECT rect;
        GetWindowRect(handle, &rect);
        LONG width = rect.right - rect.left;
        LONG height = rect.bottom - rect.top;

        flutter::EncodableMap map;
        map[flutter::EncodableValue("width")] = width;
        map[flutter::EncodableValue("height")] = height;

        result->Success(flutter::EncodableValue(map));
    }

    void setWindowSize(const flutter::MethodCall<flutter::EncodableValue>& method_call,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

        int width = 0;
        int height = 0;
        const auto* arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
        if (arguments) {
            auto width_it = arguments->find(flutter::EncodableValue("width"));
            if (width_it != arguments->end()) {
                width = std::get<int>(width_it->second);
            }

            auto height_it = arguments->find(flutter::EncodableValue("height"));
            if (height_it != arguments->end()) {
                height = std::get<int>(height_it->second);
            }
        }

        if (width < 1 || height < 1) {
            result->Error("Invalid argument", "width or height not provided");
            return;
        }

        HWND handle = GetActiveWindow();
        SetWindowPos(handle, HWND_TOP, 0, 0, width, height, SWP_NOMOVE);

        result->Success(flutter::EncodableValue(nullptr));
    }

    void getFullScreen(const flutter::MethodCall<flutter::EncodableValue>& method_call,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
        HWND handle = GetActiveWindow();

        WINDOWPLACEMENT placement;
        GetWindowPlacement(handle, &placement);

        bool isFullScreen = (placement.showCmd == SW_MAXIMIZE);
        result->Success(flutter::EncodableValue(isFullScreen));
    }

    void setFullScreen(const flutter::MethodCall<flutter::EncodableValue>& method_call,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

        bool isFullScreen = false;
        const auto* arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
        if (arguments) {
            auto fs_it = arguments->find(flutter::EncodableValue("isFullScreen"));
            if (fs_it != arguments->end()) {
                isFullScreen = std::get<bool>(fs_it->second);
            }
        }

        HWND handle = GetActiveWindow();

        WINDOWPLACEMENT placement;
        GetWindowPlacement(handle, &placement);

        if (isFullScreen) {
            placement.showCmd = SW_MAXIMIZE;
            SetWindowPlacement(handle, &placement);
        } else {
            placement.showCmd = SW_NORMAL;
            SetWindowPlacement(handle, &placement);
        }

        result->Success(flutter::EncodableValue(nullptr));
    }

    void toggleFullScreen(const flutter::MethodCall<flutter::EncodableValue>& method_call,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
        HWND handle = GetActiveWindow();

        WINDOWPLACEMENT placement;
        GetWindowPlacement(handle, &placement);

        if (placement.showCmd == SW_MAXIMIZE) {
            placement.showCmd = SW_NORMAL;
            SetWindowPlacement(handle, &placement);
        } else {
            placement.showCmd = SW_MAXIMIZE;
            SetWindowPlacement(handle, &placement);
        }

        result->Success(flutter::EncodableValue(nullptr));
    }

    void getWindowMinSize(const flutter::MethodCall<flutter::EncodableValue>& method_call,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

        flutter::EncodableMap map;
        map[flutter::EncodableValue("width")] = minWidth;
        map[flutter::EncodableValue("height")] = minHeight;

        result->Success(flutter::EncodableValue(map));
    }

    void setWindowMinSize(const flutter::MethodCall<flutter::EncodableValue>& method_call,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
        int width = 0;
        int height = 0;

        const auto* arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
        if (arguments) {
            auto width_it = arguments->find(flutter::EncodableValue("width"));
            if (width_it != arguments->end()) {
                width = std::get<int>(width_it->second);
            }
            auto height_it = arguments->find(flutter::EncodableValue("height"));
            if (height_it != arguments->end()) {
                height = std::get<int>(height_it->second);
            }
        }
        if (width < 1 || height < 1) {
            result->Error("Invalid argument", "width or height not provided");
            return;
        }

        minWidth = width;
        minHeight = height;

        updateWindowSize();
        result->Success(flutter::EncodableValue(nullptr));
    }

    void resetWindowMinSize(const flutter::MethodCall<flutter::EncodableValue>& method_call,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
        minWidth = 0;
        minHeight = 0;

        updateWindowSize();
        result->Success(flutter::EncodableValue(nullptr));
    }

    void getWindowMaxSize(const flutter::MethodCall<flutter::EncodableValue>& method_call,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

        flutter::EncodableMap map;
        map[flutter::EncodableValue("width")] = maxWidth;
        map[flutter::EncodableValue("height")] = maxHeight;

        result->Success(flutter::EncodableValue(map));
    }

    void setWindowMaxSize(const flutter::MethodCall<flutter::EncodableValue>& method_call,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
        int width = 0;
        int height = 0;

        const auto* arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
        if (arguments) {
            auto width_it = arguments->find(flutter::EncodableValue("width"));
            if (width_it != arguments->end()) {
                width = std::get<int>(width_it->second);
            }
            auto height_it = arguments->find(flutter::EncodableValue("height"));
            if (height_it != arguments->end()) {
                height = std::get<int>(height_it->second);
            }
        }
        if (width < 1 || height < 1) {
            result->Error("Invalid argument", "width or height not provided");
            return;
        }

        maxWidth = width;
        maxHeight = height;

        updateWindowSize();
        result->Success(flutter::EncodableValue(nullptr));
    }

    void resetWindowMaxSize(const flutter::MethodCall<flutter::EncodableValue>& method_call,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
        maxWidth = 0;
        maxHeight = 0;

        updateWindowSize();
        result->Success(flutter::EncodableValue(nullptr));
    }

    void setStayOnTop(const flutter::MethodCall<flutter::EncodableValue>& method_call,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
        bool stayOnTop = false;

        const auto* arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
        if (arguments) {
            auto fs_it = arguments->find(flutter::EncodableValue("isStayOnTop"));
            if (fs_it != arguments->end()) {
                stayOnTop = std::get<bool>(fs_it->second);
            }
        }

        HWND hWnd = GetActiveWindow();

        RECT rect;
        GetWindowRect(hWnd, &rect);
        SetWindowPos(hWnd, stayOnTop ? HWND_TOPMOST : HWND_NOTOPMOST, rect.left, rect.top, rect.right - rect.left, rect.bottom - rect.top, SWP_SHOWWINDOW);

        result->Success(flutter::EncodableValue(nullptr));
    }

    LRESULT CALLBACK windowProc(HWND hWnd, UINT iMessage, WPARAM wParam, LPARAM lParam) {
        if (iMessage == WM_GETMINMAXINFO) {
            bool changed = false;
            if (maxWidth > 0 && maxHeight > 0) {
                ((MINMAXINFO*)lParam)->ptMaxTrackSize.x = maxWidth;
                ((MINMAXINFO*)lParam)->ptMaxTrackSize.y = maxHeight;
                changed = true;
            }
            if (minWidth > 0 && minHeight > 0) {
                ((MINMAXINFO*)lParam)->ptMinTrackSize.x = minWidth;
                ((MINMAXINFO*)lParam)->ptMinTrackSize.y = minHeight;
                changed = true;
            }
            if (changed) {
                return FALSE;
            }
        }

        return defWindowProc(hWnd, iMessage, wParam, lParam);
    }


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

        // before default window proc
        HWND handle = GetActiveWindow();
        defWindowProc = reinterpret_cast<WNDPROC>(GetWindowLongPtr(handle, GWLP_WNDPROC));
        SetWindowLongPtr(handle, GWLP_WNDPROC, (LONG_PTR)windowProc);
    }

    WindowInterfacePlugin::WindowInterfacePlugin() {}
    WindowInterfacePlugin::~WindowInterfacePlugin() {}

    void WindowInterfacePlugin::HandleMethodCall(
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
        } else if (method_name == "getFullScreen") {
            getFullScreen(method_call, std::move(result));
        } else if (method_name == "setFullScreen") {
            setFullScreen(method_call, std::move(result));
        } else if (method_name == "toggleFullScreen") {
            toggleFullScreen(method_call, std::move(result));
        } else if (method_name == "getWindowSize") {
            getWindowSize(method_call, std::move(result));
        } else if (method_name == "setWindowSize") {
            setWindowSize(method_call, std::move(result));
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
