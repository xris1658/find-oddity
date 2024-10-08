#include "model/ItemModel.hpp"

#include <algorithm>

namespace FindOddity::Model
{
ItemModel::ItemModel(): QAbstractListModel(nullptr)
{}

ItemModel::ItemModel(const ItemModel& rhs):
    QAbstractListModel(nullptr),
    data_(rhs.data_)
{}

ItemModel::~ItemModel()
{}

int ItemModel::itemCount() const
{
    return data_.size();
}

int ItemModel::rowCount(const QModelIndex& parent) const
{
    return itemCount();
}

int ItemModel::columnCount(const QModelIndex& parent) const
{
    return columnSize();
}

QVariant ItemModel::data(const QModelIndex& index, int role) const
{
    if(auto row = index.row(); row >= 0 && row < itemCount())
    {
        switch(role)
        {
        case Role::Path:
        {
            return QVariant::fromValue<QList<QPointF>>(data_[row].points);
        }
        case Role::Description:
        {
            return QVariant::fromValue<QString>(data_[row].desc);
        }
        case Role::Found:
        {
            return QVariant::fromValue<bool>(data_[row].found);
        }
        }
    }
    return {};
}

bool ItemModel::setData(const QModelIndex& index, const QVariant& value, int role)
{
    if(auto row = index.row(); row >= 0 && row < itemCount())
    {
        switch(role)
        {
        case Role::Path:
        {
            data_[row].points = value.value<QList<QPointF>>();
            dataChanged(index, index, {Role::Path});
            return true;
        }
        case Role::Description:
        {
            data_[row].desc = value.value<QString>();
            dataChanged(index, index, {Role::Description});
            return true;
        }
        case Role::Found:
        {
            data_[row].found = value.value<bool>();
            dataChanged(index, index, {Role::Found});
            return true;
        }
        }
    }
    return false;
}

bool ItemModel::insertRows(int row, int count, const QModelIndex& parent)
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

bool ItemModel::moveRows(const QModelIndex& sourceParent, int sourceRow, int count,
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

bool ItemModel::removeRows(int row, int count, const QModelIndex& parent)
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

void ItemModel::init()
{
    for(auto& item: data_)
    {
        item.found = false;
    }
    dataChanged(index(0), index(data_.size() - 1), {Role::Found});
}

QHash<int, QByteArray> ItemModel::roleNames() const
{
    return {
        std::make_pair(Role::Path,        "im_path"),
        std::make_pair(Role::Description, "im_description"),
        std::make_pair(Role::Found,       "im_found"),
    };
}
}
