import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import Component
import module

QLauncher {
    id: app

    Connections {
        target: QTheme
        function onDarkModeChanged() {
            SettingsHelper.saveDarkMode(QTheme.darkMode)
        }
    }

    Connections {
        target: QApp
        function onUseSystemAppBarChanged() {
            SettingsHelper.saveUseSystemAppBar(QApp.useSystemAppBar)
        }
    }

    Connections {
        target: TranslateHelper
        function onCurrentChanged() {
            SettingsHelper.saveLanguage(TranslateHelper.current)
        }
    }

    Component.onCompleted: {
        Network.openLog = false
        Network.setInterceptor(function(param) {
            param.addHeader("Token", "12082asdjf73pvh32hpzbk")
        })
        QApp.init(app, Qt.locale(TranslateHelper.current))
        QApp.windowIcon = "qrc:/qt/qml/src/assets/icons/logo.ico"
        QApp.useSystemAppBar = SettingsHelper.getUseSystemAppBar()
        QTheme.darkMode = SettingsHelper.getDarkMode()
        QTheme.animationEnabled = true
        
        QRouter.routes = {
            "/": "qrc:/qt/qml/src/qml/pane/PaneBackend.qml",
            "/about": "qrc:/qt/qml/src/qml/pane/About.qml",
            "/accountContent": "qrc:/qt/qml/src/qml/pane/AccountContent.qml",
            "/crash": "qrc:/qt/qml/src/qml/pane/Crash.qml",
            "/userManagement": "qrc:/qt/qml/src/qml/pane/UserManagement.qml",
            "/licenses": "qrc:/qt/qml/src/qml/pane/Licenses.qml"
        }

        var args = Qt.application.arguments
        if (args.length >= 2 && args[1].startsWith("-crashed=")) {
            QRouter.navigate("/crash", {
                "crashFilePath": args[1].replace("-crashed=", "")
            })
        } else {
            QRouter.navigate("/")
        }
    }
}
