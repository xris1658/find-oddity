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
    struct Item
    {
        QList<QPointF> points;
        QString desc;
        bool found = false;
    };
public:
    enum Role
    {
        Path = Qt::UserRole,
        Description,
        Found,
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
public:
    Q_INVOKABLE void init();
protected:
    QHash<int, QByteArray> roleNames() const override;
private:
    std::vector<Item> data_;
};
}

Q_DECLARE_METATYPE(FindOddity::Model::ItemModel)
Q_DECLARE_METATYPE(QPointF)

#endif // FIND_ODDITY_MODEL_ITEMMODEL
