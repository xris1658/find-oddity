#include "ModelInitializer.hpp"

#include "model/StageModel.hpp"

#include <qqml.h>

namespace FindOddity::Model
{

void registerModels()
{
    qmlRegisterType<StageModel>("FindOddity.Models", 1, 0, "StageModel");
}
}
