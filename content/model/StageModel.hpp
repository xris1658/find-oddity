#ifndef FINDODDITY_CONTENT_MODEL_STAGEMODEL
#define FINDODDITY_CONTENT_MODEL_STAGEMODEL

#include "model/ItemModel.hpp"

#include <QAbstractListModel>
#include <QString>
#include <QUrl>

#include <memory>
#include <vector>

namespace FindOddity::Model
{
class StageModel: public QAbstractListModel
{
    Q_OBJECT
public:
    struct Item
    {
        QString name;
        QUrl imageUrl;
        std::unique_ptr<ItemModel> stageModel = std::make_unique<ItemModel>();
    };
public:
    enum Role
    {
        Name = Qt::UserRole,
        Image,
        Items,
        RoleCount
    };
public:
    StageModel();
    ~StageModel() override;
public:
    static constexpr int columnSize() { return 1; }
    int itemCount() const;
    int rowCount(const QModelIndex& parent) const override;
    int columnCount(const QModelIndex& parent) const override;
    QVariant data(const QModelIndex& index, int role) const override;
    bool setData(const QModelIndex& index, const QVariant& value, int role) override;
    bool insertRows(int row, int count, const QModelIndex& parent) override;
    bool moveRows(const QModelIndex& sourceParent, int sourceRow, int count,
        const QModelIndex& destParent, int destRow) override;
    bool removeRows(int row, int count, const QModelIndex& parent) override;
protected:
    QHash<int, QByteArray> roleNames() const override;
private:
    std::vector<Item> data_;
};
}

#endif // FINDODDITY_CONTENT_MODEL_STAGEMODEL
