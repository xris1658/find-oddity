qt_add_library(content STATIC)

qt_add_qml_module(content
                  URI "content"
                  VERSION 1.0
                  NO_PLUGIN
                  QML_FILES
                  Creator.qml
                  MainWindow.qml
                  Player.qml
                  SOURCES
                  model/StageModel.hpp
                  RESOURCES
                  qmldir)
