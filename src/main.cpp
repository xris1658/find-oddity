#include "model/ModelInitializer.hpp"

#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char** argv)
{
    QGuiApplication application(argc, argv);
    QQmlApplicationEngine engine;
    FindOddity::Model::registerModels();
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreated,
        [](QObject* object, const QUrl& url)
        {
            if(url == QUrl("qrc:/content/MainWindow.qml"))
            {
#if __EMSCRIPTEN__
                object->setProperty("isOnWasm", QVariant::fromValue<bool>(true));
#endif
            }
        }
    );
    engine.load("qrc:/content/MainWindow.qml");
    return application.exec();
}
