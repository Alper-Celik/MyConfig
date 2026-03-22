cmake_minimum_required(VERSION 3.16)
project(MyCustomModule VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml)

include("./qml_install.cmake")

qt_add_qml_module(AlperModule
    URI "AlperModule"
    VERSION 1.0
    SOURCES
        custommodule.h
        custommodule.cpp
)

target_link_libraries(AlperModule PRIVATE Qt6::Core Qt6::Gui Qt6::Qml)




qt_install_qml_module(AlperModule)
