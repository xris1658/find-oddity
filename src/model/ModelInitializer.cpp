#include "ModelInitializer.hpp"

#include "model/ItemModel.hpp"
#include "model/ProfessionModel.hpp"
#include "model/StageModel.hpp"

#include <qqml.h>

namespace FindOddity::Model
{
void registerModels()
{
    qmlRegisterType<ItemModel>("FindOddity.Models", 1, 0, "ItemModel");
    qmlRegisterType<ProfessionModel>("FindOddity.Models", 1, 0, "ProfessionModel");
    qmlRegisterType<StageModel>("FindOddity.Models", 1, 0, "StageModel");
}
}
