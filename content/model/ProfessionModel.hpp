#ifndef FINDODDITY_CONTENT_MODEL_PROFESSIONMODEL
#define FINDODDITY_CONTENT_MODEL_PROFESSIONMODEL

#include "model/StageModel.hpp"

#include <QAbstractListModel>
#include <QtGui/QColor>

#include <memory>
#include <vector>

namespace FindOddity::Model
{
class ProfessionModel: public QAbstractListModel
{
    Q_OBJECT
public:
    struct Item
    {
        QString name;
        QColor color;
        std::unique_ptr<StageModel> stageModel = std::make_unique<StageModel>();
    };
public:
    enum Role
    {
        Name = Qt::UserRole,
        Color,
        Stages,
        RoleCount
    };
public:
    ProfessionModel();
    ~ProfessionModel() override;
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

#endif // FINDODDITY_CONTENT_MODEL_PROFESSIONMODEL
