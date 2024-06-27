import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Component

QWindow {

    id: window
    title: qsTr("Despre")
    width: 580
    height: 550
    fixSize: true
    launchMode: QWindowType.SingleTask

    ColumnLayout {

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        spacing: 5

        RowLayout {
            Layout.topMargin: 10
            Layout.leftMargin: 15
            spacing: 14
            QText {
                text: "RaportCivic"
                font: QTextStyle.Title
            }
            QText {
                text: "v%1".arg(AppVersion.version)
                font: QTextStyle.Body
                Layout.alignment: Qt.AlignBottom
            }
        }

        RowLayout {
            Layout.topMargin: 10
            Layout.leftMargin: 15
            QText {
                text: qsTr("Aplicatie destinata activitatii civice. Genereaza rapoarte si informeaza-te!")
            }
        }

        RowLayout {
            Layout.topMargin: 10
            Layout.leftMargin: 15
            QText {
                text: qsTr("Dezvoltator:")
            }
            QText {
                text: "Chanchian Armin Andrei"
                Layout.alignment: Qt.AlignBottom
            }
        }

        RowLayout {
            Layout.leftMargin: 15

            QText {
                text: "GitHub："
            }
            QTextButton {
                id: text_hublink
                topPadding: 0
                bottomPadding: 0
                text: "https://github.com/armync"
                Layout.alignment: Qt.AlignBottom
                onClicked: {
                    Qt.openUrlExternally(text_hublink.text)
                }
            }
        }

        Item {
            Layout.topMargin: 10
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: 220
            Row {
                anchors.centerIn: parent
                spacing: 30
                Image {
                    width: 225
                    height: 150
                    source: "qrc:/qt/qml/src/assets/img/drapel_ue.png"
                }
                Image {
                    width: 225
                    height: 150
                    source: "qrc:/qt/qml/src/assets/img/drapel_ro.png"
                }
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter

            QText {
                id: text_info
                text: qsTr("Este datoria ta sa te implici!")

                ColorAnimation {
                    id: animation
                    target: text_info
                    property: "color"
                    from: "purple"
                    to: "yellow"
                    duration: 1000
                    running: true
                    loops: Animation.Infinite
                    easing.type: Easing.InOutQuad
                }
            }
        }

        RowLayout {
            Layout.leftMargin: 15
            Layout.topMargin: 100

            QFilledButton {
                text: "Licente"
                onClicked: {
                    QRouter.navigate("/licenses")
                }
            }
        }
    }
}
