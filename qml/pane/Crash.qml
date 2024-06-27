import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Component
import Qt.labs.platform

QWindow {

    id:window
    title: qsTr("Eroare")
    width: 300
    height: 400
    fixSize: true
    showMinimize: false

    property string crashFilePath

    Component.onCompleted: {
        window.stayTop = true
    }

    onInitArgument:
        (argument)=>{
            crashFilePath = argument.crashFilePath
        }

    Image{
        width: 512*0.3
        height: 512*0.3
        mipmap: true
        anchors{
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 40
        }
        source: "qrc:/qt/qml/src/assets/img/crash.png"
    }

    QText{
        id:text_info
        anchors{
            top: parent.top
            topMargin: 240
            left: parent.left
            right: parent.right
            leftMargin: 10
            rightMargin: 10
        }
        wrapMode: Text.WrapAnywhere
        text: qsTr("A intervenit un eveniment neasteptat!")
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    RowLayout{
        anchors{
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 20
        }
        QButton{
            text: qsTr("Verificare log")
            onClicked: {
                QTools.showFileInFolder(crashFilePath)
            }
        }
        Item{
            width: 30
            height: 1
        }
        QFilledButton{
            text: qsTr("Repornire aplicatie")
            onClicked: {
                QRouter.exit(931)
            }
        }
    }

}
