#include "Data.hpp"

#include "model/ProfessionModel.hpp"

#include <QColor>
#include <QDir>
#include <QFile>
#include <QString>
#include <QTextStream>
#include <QUrl>

#undef emit

#include <string>

#include <c4/yml/std/std.hpp> // Node::operator>>(std::string)
#include <ryml.hpp>

#if _WIN32
#include <windows.h>
#include <ShlObj_core.h>
#endif

#include <vector>

namespace FindOddity::DAO
{
QString systemAppDataPath()
{
#if _WIN32
    wchar_t* path = nullptr;
    SHGetKnownFolderPath(
        FOLDERID_RoamingAppData,
        KF_FLAG_NO_ALIAS,
        NULL,
        &path
    );
    return QString::fromWCharArray(path);
#elif __linux__
    return QString(std::getenv("HOME")) + "/.local/share";
#elif __EMSCRIPTEN__
    return "/home/web_user";
#endif
}

QString userDataPath()
{
#if _WIN32
    return systemAppDataPath() + "\\FindOddity";
#else
    return systemAppDataPath() + "/FindOddity";
#endif
}

QString appDataFilePath()
{
#if _WIN32
    return userDataPath() + "\\" + "data.yml";
#elif __linux__
    return userDataPath() + "/" + "data.yml";
#elif __EMSCRIPTEN__
    return userDataPath() + "/" + "data.yml";
#endif
}

template<typename T, typename U>
T childValueOr(const U& nodeRef, ryml::csubstr child, const T& value)
{
    static_assert(std::is_same_v<U, ryml::NodeRef> || std::is_same_v<U, ryml::ConstNodeRef>);
    if(nodeRef.has_child(child))
    {
        T ret;
        nodeRef[child] >> ret;
        return ret;
    }
    return value;
}

template<typename T, typename U>
T childValueOr(const U& nodeRef, ryml::csubstr child, T&& value = T())
{
    static_assert(std::is_same_v<U, ryml::NodeRef> || std::is_same_v<U, ryml::ConstNodeRef>);
    if(nodeRef.has_child(child))
    {
        T ret;
        nodeRef[child] >> ret;
        return ret;
    }
    return std::move(value);
}

void loadAppData(FindOddity::Model::ProfessionModel& model)
{
    QFile file(appDataFilePath());
    if(file.exists())
    {
        file.open(QIODevice::OpenModeFlag::ReadOnly | QIODevice::OpenModeFlag::Text);
        QTextStream stream(&file);
        auto content = stream.readAll().toUtf8();
        file.close();
        auto tree = ryml::parse_in_place(content.data());

        if(auto root = tree.rootref(); root.has_child("professions"))
        {
            if(auto professions = tree["professions"]; professions.is_seq())
            {
                for(const auto& profession: professions.children())
                {
                    auto name = childValueOr<std::string>(profession, "name");
                    auto colorString = childValueOr<std::string>(profession, "color");
                    QColor color(0, 0, 0);
                    if(QColor::isValidColorName(colorString.data()))
                    {
                        color = QColor::fromString(colorString.data());
                    }
                    auto newItemIndex = model.itemCount();
                    model.insertRow(newItemIndex);
                    model.setData(
                        model.index(newItemIndex),
                        QVariant::fromValue<QString>(QString::fromStdString(name)),
                        Model::ProfessionModel::Role::Name
                    );
                    model.setData(
                        model.index(newItemIndex),
                        QVariant::fromValue<QColor>(color),
                        Model::ProfessionModel::Role::Color
                    );
                    auto& stageModel = *static_cast<Model::StageModel*>(
                        model.data(
                            model.index(newItemIndex),
                            Model::ProfessionModel::Role::Stages
                        ).value<QObject*>()
                    );
                    if(auto stages = profession["stages"]; stages.is_seq())
                    {
                        for(const auto& stage: stages.children())
                        {
                            auto stageName = childValueOr<std::string>(stage, "name");
                            auto imageUrl = childValueOr<std::string>(stage, "image-url");
                            auto newStageIndex = stageModel.itemCount();
                            stageModel.insertRow(newStageIndex);
                            stageModel.setData(
                                stageModel.index(newStageIndex),
                                QVariant::fromValue<QString>(QString::fromStdString(stageName)),
                                Model::StageModel::Role::Name
                            );
                            stageModel.setData(
                                stageModel.index(newStageIndex),
                                QVariant::fromValue<QUrl>(QUrl(QString::fromStdString(imageUrl))),
                                Model::StageModel::Role::Image
                            );
                            auto& itemModel = *static_cast<Model::ItemModel*>(
                                stageModel.data(
                                    stageModel.index(newStageIndex),
                                    Model::StageModel::Role::Items
                                ).value<QObject*>()
                            );
                            if(auto items = stage["items"]; items.is_seq())
                            {
                                for(const auto& item: items.children())
                                {
                                    auto desc = childValueOr<std::string>(item, "desc");
                                    QList<QPointF> path;
                                    if(auto points = item["points"]; points.is_seq())
                                    {
                                        for(const auto& point: points.children())
                                        {
                                            auto x = childValueOr(point, "x", -1.0);
                                            auto y = childValueOr(point, "y", -1.0);
                                            if(x != -1 && y != -1)
                                            {
                                                path.emplace_back(
                                                    static_cast<qreal>(x),
                                                    static_cast<qreal>(y)
                                                );
                                            }
                                        }
                                    }
                                    auto newItemIndex = itemModel.itemCount();
                                    itemModel.insertRow(newItemIndex);
                                    itemModel.setData(
                                        itemModel.index(newItemIndex),
                                        QVariant::fromValue<QString>(QString::fromStdString(desc)),
                                        Model::ItemModel::Role::Description
                                    );
                                    itemModel.setData(
                                        itemModel.index(newItemIndex),
                                        QVariant::fromValue<QList<QPointF>>(path),
                                        Model::ItemModel::Role::Path
                                    );
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    else
    {
        file.open(QIODevice::OpenModeFlag::WriteOnly | QIODevice::OpenModeFlag::Truncate);
        file.write("professions: []");
        file.close();
    }
}

void saveAppData(const FindOddity::Model::ProfessionModel& model)
{
    ryml::Tree tree;
    auto root = tree.rootref();
    root.set_type(ryml::NodeType(ryml::NodeType_e::MAP));
    auto professionsNode = root.append_child(ryml::NodeInit(ryml::NodeType_e::SEQ));
    professionsNode.set_key("professions");
    auto professionCount = model.itemCount();
    for(int i = 0; i < professionCount; ++i)
    {
        auto professionNode = professionsNode.append_child(
            ryml::NodeInit(ryml::NodeType_e::MAP)
        );
        {
            auto professionName = model.data(
               model.index(i),
               Model::ProfessionModel::Role::Name
           ).value<QString>().toUtf8();
            professionNode["name"] << professionName.constData();
        }
        {
            auto color = model.data(
               model.index(i),
               Model::ProfessionModel::Role::Color
            ).value<QColor>().name(QColor::NameFormat::HexRgb).toStdString();
            professionNode["color"] << color.c_str();
        }
        auto stagesNode = professionNode.append_child(
            ryml::NodeInit(ryml::NodeType_e::SEQ)
        );
        stagesNode.set_key("stages");
        const auto& stageModel = *static_cast<const Model::StageModel*>(
            model.data(
                model.index(i),
                Model::ProfessionModel::Role::Stages
            ).value<QObject*>()
        );
        auto stageCount = stageModel.itemCount();
        for(int j = 0; j < stageCount; ++j)
        {
            auto stageNode = stagesNode.append_child(
                ryml::NodeInit(ryml::NodeType_e::MAP)
            );
            // "name", "image-url"
            {
                auto stageName = stageModel.data(
                    stageModel.index(j),
                    Model::StageModel::Role::Name
                ).value<QString>().toUtf8();
                stageNode["name"] << stageName.constData();
            }
            {
                auto imageUrl = stageModel.data(
                    stageModel.index(j),
                    Model::StageModel::Role::Image
                ).value<QUrl>().toString().toUtf8();
                stageNode["image-url"] << imageUrl.constData();
            }
            auto itemsNode = stageNode.append_child(
                ryml::NodeInit(ryml::NodeType_e::SEQ)
            );
            itemsNode.set_key("items");
            const auto &itemModel = *static_cast<const Model::ItemModel*>(
                stageModel.data(
                    stageModel.index(j),
                    Model::StageModel::Role::Items
                ).value<QObject*>()
            );
            auto itemCount = itemModel.itemCount();
            for(int k = 0; k < itemCount; ++k)
            {
                auto itemNode = itemsNode.append_child(
                    ryml::NodeInit(ryml::NodeType_e::MAP)
                );
                {
                    auto desc = itemModel.data(
                        itemModel.index(k),
                        Model::ItemModel::Role::Description
                    ).value<QString>().toUtf8();
                    itemNode["desc"] << desc.constData();
                }
                auto pointsNode = itemNode.append_child(
                    ryml::NodeInit(ryml::NodeType_e::SEQ)
                );
                pointsNode.set_key("points");
                const auto& points = itemModel.data(
                    itemModel.index(k),
                    Model::ItemModel::Role::Path
                ).value<QList<QPointF>>();
                for(auto& point: points)
                {
                    auto pointNode = pointsNode.append_child(
                        ryml::NodeInit(ryml::NodeType_e::MAP)
                    );
                    pointNode["x"] << point.x();
                    pointNode["y"] << point.y();
                }
            }
        }
    }
    QFile file(appDataFilePath());
    file.open(QIODevice::OpenModeFlag::WriteOnly | QIODevice::OpenModeFlag::Truncate);
    std::vector<char> buffer(1024);
    ryml::substr substr(buffer.data(), buffer.size());
    auto substr1 = ryml::emit_yaml(tree, substr, false);
    if(!substr1.data())
    {
        buffer.resize(substr1.len);
        substr = {buffer.data(), buffer.size()};
        substr1 = ryml::emit_yaml(tree, substr, false);
    }
    file.write(substr1.data(), substr1.size());
    file.close();
}
}
