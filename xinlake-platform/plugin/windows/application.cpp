#include <windows.h>
#include <tchar.h>

#include <filesystem>

#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>
#include "utils.h"

#pragma warning(disable : 4293)
#pragma comment(lib, "Version")

ULONG64 _getFileModified(LPTSTR lpszString);

void getAppVersion(const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    TCHAR szPath[MAX_PATH];
    if (!GetModuleFileName(NULL, szPath, MAX_PATH)) {
        result->Error("GetModuleFileName");
        return;
    }

    char version[32];
    DWORD verHandle = 0;
    DWORD verSize = GetFileVersionInfoSize(szPath, &verHandle);
    if (verSize != NULL) {

        LPSTR verData = new char[verSize];
        if (GetFileVersionInfo(szPath, verHandle, verSize, verData)) {

            UINT   size = 0;
            LPBYTE lpBuffer = NULL;
            if (VerQueryValue(verData, L"\\", (VOID FAR * FAR*) & lpBuffer, &size)) {
                if (size > 0) {
                    VS_FIXEDFILEINFO* verInfo = (VS_FIXEDFILEINFO*)lpBuffer;

                    int length = sprintf_s(version, "%hu.%hu.%hu.%hu",
                        HIWORD(verInfo->dwFileVersionMS),
                        LOWORD(verInfo->dwFileVersionMS),
                        HIWORD(verInfo->dwFileVersionLS),
                        LOWORD(verInfo->dwFileVersionLS)
                    );

                    version[length] = 0;
                }
            }
        }

        delete[] verData;
    }

    LONG64 modified = _getFileModified(szPath);

    flutter::EncodableMap map;
    map[flutter::EncodableValue("version")] = version;
    map[flutter::EncodableValue("modified-utc")] = modified;
    result->Success(flutter::EncodableValue(map));
}

void getAppDir(const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    TCHAR szPath[MAX_PATH];
    if (!GetModuleFileName(NULL, szPath, MAX_PATH)) {
        result->Error("GetModuleFileName");
        return;
    }

    std::filesystem::path appPath = Utf8FromUtf16(szPath);
    std::string appDir = appPath.parent_path().string();
    result->Success(flutter::EncodableValue(appDir.c_str()));
}

ULONG64 _getFileModified(LPTSTR lpszString) {
    HANDLE hFile = CreateFile(lpszString, GENERIC_READ, FILE_SHARE_READ, NULL,
        OPEN_EXISTING, 0, NULL);

    if (hFile == INVALID_HANDLE_VALUE) {
        return 0;
    }

    // Retrieve the file times for the file.
    ULONG64 modified = 0;
    FILETIME ftCreate, ftAccess, ftWrite;
    if (GetFileTime(hFile, &ftCreate, &ftAccess, &ftWrite)) {

        // https://stackoverflow.com/questions/6161776/convert-windows-filetime-to-second-in-unix-linux
        modified = ((static_cast<ULONG64>(ftWrite.dwHighDateTime) << 32) | ftWrite.dwLowDateTime)
            / 10000 - 11644473600000;
    }


    CloseHandle(hFile);
    return modified;
}
