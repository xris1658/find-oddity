#include "model/ModelInitializer.hpp"

#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char** argv)
{
    QGuiApplication application(argc, argv);
    QQmlApplicationEngine engine;
    FindOddity::Model::registerModels();
    engine.loadFromModule("content", "MainWindow");
    return application.exec();
}
