#include "AppDatabase.hpp"

#include "dao/Path.hpp"

#include <sqlite3.h>

namespace FindOddity::DAO
{
sqlite::database& appDatabase()
{
    static sqlite::database ret(appDataPath().toStdString());
    return ret;
}
}
