#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char** argv)
{
    QGuiApplication application(argc, argv);
    QQmlApplicationEngine engine;
    engine.loadFromModule("content", "MainWindow");
    return application.exec();
}
