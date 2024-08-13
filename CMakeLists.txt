cmake_minimum_required(VERSION 3.25)

project(FindOddity VERSION 0.1 LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Prerequisites and dependencies
find_package(QT NAMES Qt6 COMPONENTS Core Gui Qml Quick QuickTemplates2 LinguistTools REQUIRED)
find_package(Qt6 6.5 COMPONENTS Core Gui Qml Quick QuickTemplates2 LinguistTools REQUIRED)

add_subdirectory(${PROJECT_SOURCE_DIR}/third-party/sqlite3)

include_directories(
    ${PROJECT_SOURCE_DIR}/content
    ${PROJECT_SOURCE_DIR}/src
    ${PROJECT_SOURCE_DIR}/third-party/sqlite3
    ${PROJECT_SOURCE_DIR}/third-party/sqlite_modern_cpp/hdr
)

add_subdirectory(content)

qt_add_executable(FindOddity
    src/dao/AppDatabase.cpp
    src/dao/AppDatabase.hpp
    src/dao/Path.cpp
    src/dao/Path.hpp
    src/model/ProfessionModel.cpp
    src/model/StageModel.cpp
    src/model/ModelInitializer.hpp
    src/model/ModelInitializer.cpp
    src/main.cpp
)

target_link_libraries(FindOddity PRIVATE sqlite3 content Qt6::Core Qt6::Gui Qt6::Qml Qt6::Quick)
