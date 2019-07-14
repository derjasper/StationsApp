cmake_minimum_required(VERSION 2.8.12)

project(stations-app LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt5 COMPONENTS Core Quick QuickControls2 REQUIRED)

find_package(Qt5QuickCompiler)

#qtquick_compiler_add_resources(RESOURCES "qml.qrc")

add_executable(${PROJECT_NAME} "main.cpp" "fslistmodel.h" "fslistmodel.cpp" "qml.qrc")#${RESOURCES})

target_link_libraries(${PROJECT_NAME} Qt5::Core Qt5::Quick Qt5::QuickControls2)
