#include <windows.h>
// #include <tchar.h>

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
