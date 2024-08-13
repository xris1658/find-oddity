#ifndef FIND_ODDITY_MODEL_ITEMMODEL
#define FIND_ODDITY_MODEL_ITEMMODEL

#include <QAbstractListModel>
#include <QPointF>
#include <QString>

#include <vector>

namespace FindOddity::Model
{
class ItemModel: public QAbstractListModel
{
    Q_OBJECT
public:
    enum Role
    {
        Path = Qt::UserRole,
        Description,
        RoleCount
    };
public:
    ItemModel();
    ItemModel(const ItemModel& rhs);
    ~ItemModel() override;
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
    std::vector<std::pair<std::vector<QPointF>, QString>> data_;
};
}

Q_DECLARE_METATYPE(FindOddity::Model::ItemModel)

#endif // FIND_ODDITY_MODEL_ITEMMODEL
