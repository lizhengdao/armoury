#include <Windows.h>

#include "utils.h"

std::string Utf8FromUtf16(const wchar_t* utf16_string) {
    if (utf16_string == nullptr) {
        return std::string();
    }

    int target_length = ::WideCharToMultiByte(CP_UTF8, WC_ERR_INVALID_CHARS, utf16_string,
        -1, nullptr, 0, nullptr, nullptr);
    if (target_length == 0) {
        return std::string();
    }

    std::string utf8_string;
    utf8_string.resize(target_length);
    int converted_length = ::WideCharToMultiByte(
        CP_UTF8, WC_ERR_INVALID_CHARS, utf16_string,
        -1, utf8_string.data(), target_length, nullptr, nullptr);

    if (converted_length == 0) {
        return std::string();
    }

    return utf8_string;
}

std::wstring WStringFromString(const std::string& string) {
    std::vector<wchar_t> buff(
        MultiByteToWideChar(CP_ACP, 0, string.c_str(), (int)(string.size() + 1), 0, 0)
    );

    MultiByteToWideChar(CP_ACP, 0, string.c_str(), (int)(string.size() + 1), &buff[0], (int)(buff.size()));

    return std::wstring(&buff[0]);
}
