#ifndef FINDODDITY_SRC_DAO_APPDATABASE
#define FINDODDITY_SRC_DAO_APPDATABASE

#include <sqlite3.h>
#include <sqlite_modern_cpp.h>

namespace FindOddity::DAO
{
sqlite::database& appDatabase();
}

#endif
