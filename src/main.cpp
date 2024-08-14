#include "dao/Data.hpp"
#include "model/ModelInitializer.hpp"
#include "model/ProfessionModel.hpp"

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickWindow>
#include <QVariant>

int main(int argc, char** argv)
{
    QGuiApplication application(argc, argv);
    QQmlApplicationEngine engine;
    FindOddity::Model::registerModels();
    QQuickWindow* mainWindow = nullptr;
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreated,
        [&](QObject* object, const QUrl& url)
        {
            if(url == QUrl("qrc:/content/MainWindow.qml"))
            {
                mainWindow = static_cast<QQuickWindow*>(object);
#if __EMSCRIPTEN__
                object->setProperty("isOnWasm", QVariant::fromValue<bool>(true));
#endif
            }
        }
    );
    engine.load("qrc:/content/MainWindow.qml");
    FindOddity::Model::ProfessionModel professionModel;
    FindOddity::DAO::loadAppData(professionModel);
    mainWindow->setProperty(
        "professionModel",
        QVariant::fromValue<QObject*>(&professionModel)
    );
    return application.exec();
}
