#include "model/ProfessionModel.hpp"

namespace FindOddity::Model
{

ProfessionModel::ProfessionModel(): QAbstractListModel(nullptr)
{}

ProfessionModel::~ProfessionModel()
{}

int ProfessionModel::itemCount() const
{
    return data_.size();
}

int ProfessionModel::rowCount(const QModelIndex& parent) const
{
    return itemCount();
}

int ProfessionModel::columnCount(const QModelIndex& parent) const
{
    return columnSize();
}

QVariant ProfessionModel::data(const QModelIndex& index, int role) const
{
    if(auto row = index.row(); row >= 0 && row < itemCount())
    {
        switch(role)
        {
        case Role::Name:
        {
            return QVariant::fromValue<QString>(data_[row].name);
        }
        case Role::Stages:
        {
            return QVariant::fromValue<QObject*>(
                const_cast<StageModel*>(data_[row].stageModel.get())
            );
        }
        }
    }
    return {};
}

bool ProfessionModel::setData(const QModelIndex& index, const QVariant& value, int role)
{
    if(auto row = index.row(); row >= 0 && row < itemCount())
    {
        switch(role)
        {
        case Role::Name:
        {
            data_[row].name = value.value<QString>();
            dataChanged(index, index, {Role::Name});
            return true;
        }
        }
    }
    return false;
}

bool ProfessionModel::insertRows(int row, int count, const QModelIndex& parent)
{
    if(parent == QModelIndex()
        && row >= 0 && row <= itemCount()
        && count > 0)
    {
        beginInsertRows(parent, row, row + count - 1);
        std::generate_n(
            std::inserter(data_, data_.begin() + row),
            count,
            []()
            {
                return Item();
            }
        );
        endInsertRows();
        return true;
    }
    return false;
}

bool ProfessionModel::moveRows(const QModelIndex& sourceParent, int sourceRow, int count, const QModelIndex& destParent, int destRow)
{
    if(sourceParent == QModelIndex() && destParent == QModelIndex()
        && sourceRow >= 0 && sourceRow < itemCount()
        && count > 0 && sourceRow + count <= itemCount()
        && destRow >= 0 && destRow < itemCount())
    {
        if(sourceRow > destRow)
        {
            beginMoveRows(sourceParent, sourceRow, sourceRow + count - 1,
                destParent, destRow
                );
            std::rotate(
                data_.begin() + destRow,
                data_.begin() + sourceRow,
                data_.begin() + sourceRow + count
                );
            endMoveRows();
            return true;
        }
        else if(destRow >= sourceRow + count)
        {
            beginMoveRows(sourceParent, sourceRow, sourceRow + count - 1,
                destParent, destRow
                );
            std::rotate(
                data_.begin() + sourceRow,
                data_.begin() + sourceRow + count,
                data_.begin() + destRow + 1
                );
            endMoveRows();
            return true;
        }
    }
    return false;
}

bool ProfessionModel::removeRows(int row, int count, const QModelIndex& parent)
{
    if(parent == QModelIndex()
        && row >= 0 && row < itemCount()
        && count > 0 && row + count <= itemCount())
    {
        beginRemoveRows(parent, row, row + count - 1);
        data_.erase(data_.begin() + row, data_.begin() + row + count);
        endRemoveRows();
        return true;
    }
    return false;
}

QHash<int, QByteArray> ProfessionModel::roleNames() const
{
    return {
        std::make_pair(Role::Name, "pm_name"),
        std::make_pair(Role::Stages, "pm_stage_model")
    };
}
}
