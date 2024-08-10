#include "model/StageModel.hpp"

#include <algorithm>

namespace FindOddity::Model
{
StageModel::StageModel(): QAbstractListModel(nullptr)
{}

StageModel::StageModel(const StageModel& rhs):
    QAbstractListModel(nullptr),
    data_(rhs.data_)
{}

StageModel::~StageModel()
{}

int StageModel::itemCount() const
{
    return data_.size();
}

int StageModel::rowCount(const QModelIndex& parent) const
{
    return itemCount();
}

int StageModel::columnCount(const QModelIndex& parent) const
{
    return columnSize();
}

QVariant StageModel::data(const QModelIndex& index, int role) const
{
    if(auto row = index.row(); row >= 0 && row < itemCount())
    {
        switch(role)
        {
        case Role::Path:
        {
            return QVariant::fromValue<std::vector<QPointF>>(data_[row].first);
        }
        case Role::Description:
        {
            return QVariant::fromValue<QString>(data_[row].second);
        }
        }
    }
    return {};
}

bool StageModel::setData(const QModelIndex& index, const QVariant& value, int role)
{
    if(auto row = index.row(); row >= 0 && row < itemCount())
    {
        switch(role)
        {
        case Role::Path:
        {
            data_[row].first = value.value<std::vector<QPointF>>();
            return true;
        }
        case Role::Description:
        {
            data_[row].second = value.value<QString>();
            return true;
        }
        }
    }
    return false;
}

bool StageModel::insertRows(int row, int count, const QModelIndex& parent)
{
    if(parent == QModelIndex()
        && row >= 0 && row <= itemCount()
        && count > 0)
    {
        beginInsertRows(parent, row, row + count - 1);
        std::fill_n(
            std::inserter(data_, data_.begin() + row),
            count,
            decltype(data_)::value_type()
        );
        endInsertRows();
        return true;
    }
    return false;
}

bool StageModel::moveRows(const QModelIndex& sourceParent, int sourceRow, int count,
    const QModelIndex& destParent, int destRow)
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

bool StageModel::removeRows(int row, int count, const QModelIndex& parent)
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

QHash<int, QByteArray> StageModel::roleNames() const
{
    return {
        std::make_pair(Role::Path, "sm_path"),
        std::make_pair(Role::Description, "sm_description")
    };
}
}
