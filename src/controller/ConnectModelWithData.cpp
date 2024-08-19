#include "ConnectModelWithData.hpp"

#include "dao/Data.hpp"
#include "model/ItemModel.hpp"
#include "model/ProfessionModel.hpp"
#include "model/StageModel.hpp"

#include <QObject>

namespace FindOddity::Controller
{
void connectToItemModel(
    FindOddity::Model::ProfessionModel& professionModel,
    FindOddity::Model::ItemModel& itemModel)
{
    QObject::connect(
        &itemModel, &FindOddity::Model::ItemModel::rowsInserted,
        [&](const QModelIndex& parent, int first, int last)
        {
            FindOddity::DAO::saveAppData(professionModel);
        }
    );
    QObject::connect(
        &itemModel, &FindOddity::Model::ItemModel::rowsRemoved,
        [&](const QModelIndex& parent, int first, int last)
        {
            FindOddity::DAO::saveAppData(professionModel);
        }
    );
    QObject::connect(
        &itemModel, &FindOddity::Model::ItemModel::dataChanged,
        [&]()
        {
            FindOddity::DAO::saveAppData(professionModel);
        }
    );
}

void connectToStageModel(
    FindOddity::Model::ProfessionModel& professionModel,
    FindOddity::Model::StageModel& stageModel)
{
    QObject::connect(
        &stageModel, &FindOddity::Model::StageModel::rowsInserted,
        [&](const QModelIndex& parent, int first, int last)
        {
            for(int i = first; i <= last; ++i)
            {
                connectToItemModel(
                    professionModel,
                    *static_cast<FindOddity::Model::ItemModel*>(
                        stageModel.data(
                            stageModel.index(i),
                            FindOddity::Model::StageModel::Role::Items
                        ).value<QObject*>()
                    )
                );
            }
            FindOddity::DAO::saveAppData(professionModel);
        }
    );
    QObject::connect(
        &stageModel, &FindOddity::Model::StageModel::dataChanged,
        [&]()
        {
            FindOddity::DAO::saveAppData(professionModel);
        }
    );
    QObject::connect(
        &stageModel, &FindOddity::Model::StageModel::rowsRemoved,
        [&]()
        {
            FindOddity::DAO::saveAppData(professionModel);
        }
    );
    for(int i = 0; i < stageModel.itemCount(); ++i)
    {
        connectToItemModel(
            professionModel,
            *static_cast<FindOddity::Model::ItemModel*>(
                stageModel.data(
                    stageModel.index(i),
                    FindOddity::Model::StageModel::Role::Items
                ).value<QObject*>()
            )
        );
    }
}

void connectToProfessionModel(FindOddity::Model::ProfessionModel& professionModel)
{
    QObject::connect(
        &professionModel, &FindOddity::Model::ProfessionModel::rowsInserted,
        [&](const QModelIndex& parent, int first, int last)
        {
            for(int i = first; i <= last; ++i)
            {
                connectToStageModel(
                    professionModel,
                    *static_cast<FindOddity::Model::StageModel*>(
                        professionModel.data(
                            professionModel.index(i),
                            FindOddity::Model::ProfessionModel::Role::Stages
                        ).value<QObject*>()
                    )
                );
            }
            FindOddity::DAO::saveAppData(professionModel);
        }
    );
    QObject::connect(
        &professionModel, &FindOddity::Model::ProfessionModel::dataChanged,
        [&]()
        {
            FindOddity::DAO::saveAppData(professionModel);
        }
    );
    QObject::connect(
        &professionModel, &FindOddity::Model::ProfessionModel::rowsRemoved,
        [&]()
        {
            FindOddity::DAO::saveAppData(professionModel);
        }
    );
    for(int i = 0; i < professionModel.itemCount(); ++i)
    {
        connectToStageModel(
            professionModel,
            *static_cast<FindOddity::Model::StageModel*>(
                professionModel.data(
                    professionModel.index(i),
                    FindOddity::Model::ProfessionModel::Role::Stages
                ).value<QObject*>()
            )
        );
    }
}
}