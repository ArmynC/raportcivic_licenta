cmake_minimum_required(VERSION 3.20)

if (BUILD_STATIC_LIB)
    project(component VERSION 1.0)
else()
    project(componentplugin VERSION 1.0)
endif()

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/.cmake/)

# cmake generic setup
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_definitions(-DCOMPONENT_VERSION=1,7,4,0)

if (BUILD_STATIC_LIB)
    add_definitions(-DCOMPONENT_BUILD_STATIC_LIB)
endif()

# compiler parameter
option(COMPONENT_BUILD_STATIC_LIB "Build static library." OFF)

# qt dependencies
find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core Quick Qml)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Quick Qml)

set(QT_SDK_DIR "${Qt${QT_VERSION_MAJOR}_DIR}/../../..")
cmake_path(SET QT_SDK_DIR NORMALIZE ${QT_SDK_DIR})

# external path of component (set or default fallback)
set(COMPONENT_QML_PLUGIN_DIRECTORY "" CACHE PATH "Path to UI Component")
if(NOT COMPONENT_QML_PLUGIN_DIRECTORY)
    set(COMPONENT_QML_PLUGIN_DIRECTORY ${QT_SDK_DIR}/qml/Component)
endif()

# cmake setup
qt_standard_project_setup()

# internationalization
find_program(QT_LUPDATE NAMES lupdate)
find_program(QT_LRELEASE NAMES lrelease)

set(TS_FILES component_en_US.ts component_ro_RO.ts)
set(QM_FILES component_en_US.qm component_ro_RO.qm)
foreach(TS_FILE ${TS_FILES})
    if (NOT EXISTS ${CMAKE_CURRENT_LIST_DIR}/${TS_FILE})
        execute_process(COMMAND ${QT_LUPDATE} ${CMAKE_CURRENT_LIST_DIR} -ts ${TS_FILE} WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR})
    endif()
endforeach()

add_custom_target(translations ALL
    COMMAND ${QT_LUPDATE} ${CMAKE_CURRENT_LIST_DIR} -ts ${TS_FILES}
    COMMAND ${QT_LRELEASE} ${TS_FILES}
    WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
    DEPENDS ${TS_FILES}
)

foreach(QM_FILE ${QM_FILES})
    add_custom_command(
        OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/Qt${QT_VERSION_MAJOR}/imports/Component/i18n/${QM_FILE}
        COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_LIST_DIR}/${QM_FILE} ${CMAKE_CURRENT_SOURCE_DIR}/Qt${QT_VERSION_MAJOR}/imports/Component/i18n/${QM_FILE}
        DEPENDS translations
    )
endforeach()

# cpp iterate
file(GLOB_RECURSE CPP_FILES *.cpp *.h)
foreach(filepath ${CPP_FILES})
    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
    list(APPEND sources_files ${filename})
endforeach(filepath)

if (NOT COMPONENT_BUILD_STATIC_LIB)
    list(REMOVE_ITEM sources_files Component.h Component.cpp)
endif()

# qml iterate
file(GLOB_RECURSE QML_PATHS *.qml qmldir)
foreach(filepath ${QML_PATHS})
    if(${filepath} MATCHES "Qt${QT_VERSION_MAJOR}/")
        string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
        if(${filename} MATCHES "qmldir")
            list(APPEND resource_files ${filename})
        else()
            list(APPEND qml_files ${filename})
        endif()
    endif()
endforeach(filepath)

# assets iterate
file(GLOB_RECURSE RES_PATHS *.png *.jpg *.svg *.ico *.ttf *.webp *.js *.qm)
foreach(filepath ${RES_PATHS})
    if(${filepath} MATCHES "Qt${QT_VERSION_MAJOR}/")
        string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
        list(APPEND resource_files ${filename})
    endif()
endforeach(filepath)

# resource export path
foreach(filepath IN LISTS qml_files resource_files)
    string(REPLACE "Qt${QT_VERSION_MAJOR}/imports/Component/" "" filename ${filepath})
    set_source_files_properties(${filepath} PROPERTIES QT_RESOURCE_ALIAS ${filename})
endforeach()

if (COMPONENT_BUILD_STATIC_LIB)
    set(LIB_TYPE "STATIC")
else()
    set(LIB_TYPE "SHARED")
endif()

if (COMPONENT_BUILD_STATIC_LIB)
    set(PLUGIN_TARGET_NAME "")
else()
    # dynamic library
    set(PLUGIN_TARGET_NAME ${PROJECT_NAME})
endif()

# windows platform
set(COMPONENT_VERSION_RC_PATH "")
if(WIN32)
    set(COMPONENT_VERSION_RC_PATH ${CMAKE_CURRENT_BINARY_DIR}/version_${PROJECT_NAME}.rc)
    configure_file(
        ${CMAKE_CURRENT_SOURCE_DIR}/.cmake/version_dll.rc.in
        ${COMPONENT_VERSION_RC_PATH}
    )
endif()

if(COMPONENT_BUILD_STATIC_LIB)
    set(COMPONENT_QML_PLUGIN_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/Component)
endif()

qt_add_library(${PROJECT_NAME} ${LIB_TYPE})

qt_add_qml_module(${PROJECT_NAME}
    PLUGIN_TARGET ${PLUGIN_TARGET_NAME}
    OUTPUT_DIRECTORY ${COMPONENT_QML_PLUGIN_DIRECTORY}
    VERSION 1.0
    URI "Component"
    TYPEINFO "plugins.qmltypes"
    SOURCES ${sources_files} ${COMPONENT_VERSION_RC_PATH}
    QML_FILES ${qml_files}
    RESOURCES ${resource_files}
    RESOURCE_PREFIX "/qt/qml"
)

target_compile_definitions(${PROJECT_NAME}
    PRIVATE
    HAVE_CONFIG_H
)

if(MINGW)
    set_target_properties(${PROJECT_NAME} PROPERTIES PREFIX "")
endif()

if(MSVC)
    set_target_properties(${PROJECT_NAME} PROPERTIES DEBUG_POSTFIX "d")
endif()

target_link_libraries(${PROJECT_NAME} PUBLIC
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Quick
    Qt${QT_VERSION_MAJOR}::Qml
)

install(DIRECTORY ${COMPONENT_QML_PLUGIN_DIRECTORY} DESTINATION ${CMAKE_INSTALL_PREFIX}/imports)
