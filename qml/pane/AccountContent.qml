import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Component
import module

QWindow {
    id: window
    width: 400
    height: 400
    fixSize: true

    QInfoBar {
        id: infoBar
        root: window
    }

    function showErrorPos(text, y) {
        infoBar.layoutY = y
        infoBar.showError(text)
    }

    function showSuccessPos(text, y) {
        infoBar.layoutY = y
        infoBar.showSuccess(text)
    }

    Loader {
        id: contentLoader
        anchors.fill: parent
        source: "AccountLogin.qml"
    }

    function loadLoginAccount() {
        unloadPageAnimation.start()
        unloadPageAnimation.onStopped.connect(function () {
            contentLoader.source = "AccountLogin.qml"
            loadPageAnimation.start()
        })
    }

    function loadRegisterAccount() {
        unloadPageAnimation.start()
        unloadPageAnimation.onStopped.connect(function () {
            contentLoader.source = "AccountRegister.qml"
            loadPageAnimation.start()
        })
    }

    SequentialAnimation {
        id: loadPageAnimation
        ParallelAnimation {
            NumberAnimation {
                target: contentLoader.item
                property: "opacity"
                from: 0
                to: 1
                duration: 200
            }
            NumberAnimation {
                target: contentLoader.item
                property: "scale"
                from: 0.8
                to: 1
                duration: 200
            }
        }
    }

    SequentialAnimation {
        id: unloadPageAnimation
        ParallelAnimation {
            NumberAnimation {
                target: contentLoader.item
                property: "opacity"
                from: 1
                to: 0
                duration: 200
            }
            NumberAnimation {
                target: contentLoader.item
                property: "scale"
                from: 1
                to: 0.8
                duration: 200
            }
        }
    }
}
