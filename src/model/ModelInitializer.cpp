#include "ModelInitializer.hpp"

#include "model/ProfessionModel.hpp"
#include "model/StageModel.hpp"

#include <qqml.h>

namespace FindOddity::Model
{

void registerModels()
{
    qmlRegisterType<ProfessionModel>("FindOddity.Models", 1, 0, "ProfessionModel");
    qmlRegisterType<StageModel>("FindOddity.Models", 1, 0, "StageModel");
}
}
