#include "Path.hpp"

#if _WIN32
#include <windows.h>
#include <ShlObj_core.h>
#endif

#include <mutex>
#include <vector>

namespace FindOddity::DAO
{
QString appDataPath()
{
#if _WIN32
    wchar_t* path = nullptr;
    SHGetKnownFolderPath(
        FOLDERID_RoamingAppData,
        KF_FLAG_NO_ALIAS,
        NULL,
        &path
    );
    return QString::fromWCharArray(path) + "\\FindOddity";
#elif __linux__
    return QString(std::getenv("HOME")) + "/.local/share/FindOddity";
#endif
}
}
