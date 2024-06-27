# Set the executable output directory
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin/${CMAKE_BUILD_TYPE})

if(APPLE)
    set(APPLICATION_DIR_PATH ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${PROJECT_NAME}.app/Contents/MacOS)
else()
    set(APPLICATION_DIR_PATH ${CMAKE_RUNTIME_OUTPUT_DIRECTORY})
endif()

add_subdirectory(component)
add_subdirectory(libs/libsodium)

# File paths
set(PROJECT_SOURCES
    main.cpp
    dev/AppVersion.cpp
    dev/units/CircularReveal.cpp
    dev/util/AccountManager.cpp
    dev/util/AccountStorage.cpp
    dev/util/DbManager.cpp
    dev/util/ExifExtractor.cpp
    dev/util/FileReader.cpp
    dev/util/JsonParser.cpp
    dev/util/Log.cpp
    dev/util/PasswordHasher.cpp
    dev/util/PasswordValidator.cpp
    dev/util/ProfileValidator.cpp
    dev/util/QmlBridge.cpp
    dev/util/ReportBridge.cpp
    dev/util/ReportJsonManager.cpp
    dev/util/SettingsHelper.cpp
    dev/util/TinyEXIF.cpp
    dev/util/tinyxml2.cpp
    dev/util/TranslateHelper.cpp
    dev/util/UrlOpener.cpp
    dev/util/NetworkCore.cpp
)

set(HEADER
    build.h
    dev/AppVersion.h
    dev/singleton.h
    dev/stdafx.h
    dev/units/CircularReveal.h
    dev/util/AccountManager.h
    dev/util/AccountStorage.h
    dev/util/DbManager.h
    dev/util/ExifExtractor.h
    dev/util/FileReader.h
    dev/util/JsonParser.h
    dev/util/Log.h
    dev/util/PasswordHasher.h
    dev/util/PasswordValidator.h
    dev/util/ProfileValidator.h
    dev/util/QmlBridge.h
    dev/util/ReportBridge.h
    dev/util/ReportJsonManager.h
    dev/util/SettingsHelper.h
    dev/util/TinyEXIF.h
    dev/util/tinyxml2.h
    dev/util/TranslateHelper.h
    dev/util/UrlOpener.h
    dev/util/NetworkCore.h
)

if(WIN32)
    list(APPEND HEADER
        dev/AppDmp.h
    )
endif()

set(QML_SOURCES
    qml/App.qml
    qml/board/ItemsBase.qml
    qml/board/ItemsMain.qml
    qml/board/SharedState.qml
    qml/pane/About.qml
    qml/pane/AccountContent.qml
    qml/pane/AccountLogin.qml
    qml/pane/AccountRegister.qml
    qml/pane/Crash.qml
    qml/pane/Licenses.qml
    qml/pane/PaneBackend.qml
    qml/screen/544Guide.qml
    qml/screen/CaseGuide.qml
    qml/screen/CivicalGuide.qml
    qml/screen/Home.qml
    qml/screen/ReportData.qml
    qml/screen/ReportDetails.qml
    qml/screen/ReportDisplay.qml
    qml/screen/ReportInput.qml
    qml/screen/ReportSelection.qml
    qml/screen/Settings.qml
    qml/screen/UserManagement.qml
)

set(RESOURCES
    assets/data/judete.json

    assets/data/report_templates/bollard_request.json
    assets/data/report_templates/building_documents.json
    assets/data/report_templates/car_park_sidewalk.json
    assets/data/report_templates/green_space.json
    assets/data/report_templates/street_dogs.json
    assets/data/report_templates/reusable/attachment.json
    assets/data/report_templates/reusable/ending.json
    assets/data/report_templates/reusable/introduction.json
    assets/data/report_templates/reusable/l544_2001.json
    assets/data/report_templates/reusable/location.json
    assets/data/report_templates/reusable/og27.json

    assets/icons/logo.png
    assets/icons/logo.ico
    assets/icons/logo_dark_word.png
    assets/icons/logo_light_word.png

    assets/img/b1.png
    assets/img/b2.png
    assets/img/b3.png
    assets/img/crash.png
    assets/img/drapel_ro.png
    assets/img/drapel_ue.png
    assets/img/waves_header.png
    assets/img/circle/c1.png
    assets/img/circle/c2.png
    assets/img/circle/c3.png
    assets/img/circle/c4.png
    assets/img/circle/c5.png
    assets/img/circle/c6.png
    assets/img/circle/c7.png

    assets/img/btn/FilePicker.png
    assets/img/btn/PersonPicture.png
    assets/img/btn/RichEditBox.png

    assets/pdf/ghid_544.pdf
    assets/pdf/ghid_cazuri.pdf
    assets/pdf/ghid_civic.pdf

    assets/svg/home.svg
    assets/svg/home_dark.svg

    legal/assets.txt
    legal/libsodium-isc.txt
    legal/qt-lgpl-3.0.txt
    legal/qml-unit-mit.txt

    ca.pem

    qml/board/qmldir
)

# Qt dependencies
find_package(Qt6 6.7 REQUIRED COMPONENTS
    Core
    Qml
    Gui
    Quick
    QuickControls2
    Network
    Sql
    Svg
    Pdf
    LinguistTools
    WebSockets
    Positioning
    Multimedia
    Core5Compat
)

# Include libsodium
set(LIBSODIUM_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/libs/libsodium/include)
set(LIBSODIUM_LIBRARY ${CMAKE_CURRENT_SOURCE_DIR}/libs/libsodium/lib/libsodium.a)

include_directories(${LIBSODIUM_INCLUDE_DIR})

# https://doc.qt.io/qt-6/qt-standard-project-setup.html
qt_standard_project_setup(REQUIRES 6.5)

# https://doc.qt.io/qt-6/cmake-commands-qtlinguisttools.html
find_program(QT_LUPDATE NAMES lupdate REQUIRED)
find_program(QT_LRELEASE NAMES lrelease REQUIRED)

if(NOT QT_LUPDATE OR NOT QT_LRELEASE)
    message(FATAL_ERROR "Qt Linguist tools (lupdate and lrelease) not found.")
endif()

# .ts files path
set(TS_FILES
    ${CMAKE_CURRENT_LIST_DIR}/lang/${PROJECT_NAME}_en_US.ts
    ${CMAKE_CURRENT_LIST_DIR}/lang/${PROJECT_NAME}_ro_RO.ts
)

# generate .ts if not present
foreach(TS_FILE ${TS_FILES})
    if (NOT EXISTS ${TS_FILE})
        execute_process(COMMAND ${QT_LUPDATE} ${CMAKE_CURRENT_SOURCE_DIR} -ts ${TS_FILE})
    endif()
endforeach()

add_custom_target(Script-UpdateTranslations
    # update .ts files by scanning the source directory
    COMMAND ${QT_LUPDATE} ${CMAKE_CURRENT_SOURCE_DIR} -ts ${CMAKE_CURRENT_LIST_DIR}/lang/${PROJECT_NAME}_en_US.ts ${CMAKE_CURRENT_LIST_DIR}/lang/${PROJECT_NAME}_ro_RO.ts

    # generate .qm files from .ts files
    COMMAND ${QT_LRELEASE} ${CMAKE_CURRENT_LIST_DIR}/lang/${PROJECT_NAME}_en_US.ts ${CMAKE_CURRENT_LIST_DIR}/lang/${PROJECT_NAME}_ro_RO.ts

    # create lang directory in the app directory
    COMMAND ${CMAKE_COMMAND} -E make_directory ${APPLICATION_DIR_PATH}/lang

    # copy .qm files to the defined path
    COMMAND ${CMAKE_COMMAND} -E copy
        ${CMAKE_CURRENT_LIST_DIR}/lang/${PROJECT_NAME}_en_US.qm
        ${CMAKE_CURRENT_LIST_DIR}/lang/${PROJECT_NAME}_ro_RO.qm
        ${APPLICATION_DIR_PATH}/lang

    SOURCES ${TS_FILES}

    COMMENT "Updating translations"
    WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/lang
)

# https://doc.qt.io/qt-6/qt-add-executable.html
if(WIN32)
    # Define the Windows app build icon
    set(APP_ICON_RESOURCE_WINDOWS "${CMAKE_CURRENT_SOURCE_DIR}/assets/icons/app_icon.rc")
    add_executable(${PROJECT_NAME} WIN32
        ${PROJECT_SOURCES}
        ${APP_ICON_RESOURCE_WINDOWS}
    )
else()
    add_executable(${PROJECT_NAME}
        ${PROJECT_SOURCES}
    )
endif()

# https://doc.qt.io/qt-6/cmake-build-qml-application.html
# qrc:/qt/qml/${URI}/...
qt_add_qml_module(${PROJECT_NAME}
    URI src
    VERSION 1.0
    SOURCES ${PROJECT_SOURCES} ${HEADER}
    QML_FILES ${QML_SOURCES}
    RESOURCES ${RESOURCES}
)

add_dependencies(${PROJECT_NAME} Script-UpdateTranslations)

set_target_properties(${PROJECT_NAME} PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE FALSE
    WIN32_EXECUTABLE TRUE
)

# MacOS application icon
if(APPLE)
    set_source_files_properties(${CMAKE_CURRENT_SOURCE_DIR}/assets/icons/logo.icns PROPERTIES MACOSX_PACKAGE_LOCATION "Resources")
    set_target_properties(${PROJECT_NAME} PROPERTIES
        MACOSX_BUNDLE_ICON_FILE logo.icns
    )
endif()

# Import (give the entire path) for the header files.
# Avoids QML Register Type warning reports.
target_include_directories(${PROJECT_NAME} PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/dev/units
    ${CMAKE_CURRENT_SOURCE_DIR}/dev/util
)

# Modify precompile definitions.
# https://doc.qt.io/qt-6/qmessagelogcontext.html
target_compile_definitions(${PROJECT_NAME} PRIVATE
    QT_MESSAGELOGCONTEXT
)

target_link_libraries(${PROJECT_NAME}
    PRIVATE
        Qt${QT_VERSION_MAJOR}::Core
        Qt${QT_VERSION_MAJOR}::Qml
        Qt${QT_VERSION_MAJOR}::Gui
        Qt${QT_VERSION_MAJOR}::Quick
        Qt${QT_VERSION_MAJOR}::QuickControls2
        Qt${QT_VERSION_MAJOR}::Network
        Qt${QT_VERSION_MAJOR}::Sql
        Qt${QT_VERSION_MAJOR}::Svg
        Qt${QT_VERSION_MAJOR}::Pdf
        Qt${QT_VERSION_MAJOR}::WebSockets
        Qt${QT_VERSION_MAJOR}::Positioning
        Qt${QT_VERSION_MAJOR}::Core5Compat
        componentplugin
        libsodium
)

include(GNUInstallDirs)
install(TARGETS ${PROJECT_NAME}
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

if(CMAKE_BUILD_TYPE MATCHES "Release")
    find_program(QT_DEPLOY_TOOL NAMES macdeployqt windeployqt)
    if(QT_DEPLOY_TOOL)
        add_custom_target(Script-DeployRelease
            COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_SOURCE_DIR}/dist
            COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_RUNTIME_OUTPUT_DIRECTORY} ${CMAKE_SOURCE_DIR}/dist
            COMMAND ${QT_DEPLOY_TOOL} ${CMAKE_SOURCE_DIR}/dist/${PROJECT_NAME}${CMAKE_EXECUTABLE_SUFFIX} -qmldir=${CMAKE_CURRENT_LIST_DIR}
            COMMENT "Deploying Qt Dependencies After Build..."
            SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/CMakeLists.txt
            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        )
    else()
        message(WARNING "Qt deployment tool not found. Skipping deployment.")
    endif()
endif()
