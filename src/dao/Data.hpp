#ifndef FINDODDITY_SRC_DAO_DATA
#define FINDODDITY_SRC_DAO_DATA

namespace FindOddity::Model
{
class ProfessionModel;
}

namespace FindOddity::DAO
{
void loadAppData(FindOddity::Model::ProfessionModel& model);

void saveAppData(const FindOddity::Model::ProfessionModel& model);
}

#endif // FINDODDITY_SRC_DAO_DATA
