qt_add_library(content STATIC)

qt_add_qml_module(content
                  URI "content"
                  VERSION 1.0
                  NO_PLUGIN
                  QML_FILES
                  About.qml
                  AboutQt.qml
                  Creator.qml
                  MainWindow.qml
                  Player.qml
                  ProfessionList.qml
                  StageList.qml
                  SOURCES
                  model/ItemModel.hpp
                  model/ProfessionModel.hpp
                  model/StageModel.hpp
                  RESOURCES
                  qmldir
                  ./font/wqy-microhei.ttc
                  ./images/qtlogo-64.png
)
