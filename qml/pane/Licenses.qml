import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Component
import module

QWindow {
    id: window
    title: qsTr("Licenta")
    width: 550
    height: 530
    fixSize: true
    launchMode: QWindowType.SingleTask

    FileReader {
        id: fileReader
    }

    contentData: ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 20

        QText {
            id: titleText
            text: qsTr("Intelectualitate externa")
            font: QTextStyle.Subtitle
            Layout.alignment: Qt.AlignHCenter
        }

        QFrame {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignHCenter
            padding: 10

            contentData: ScrollView {
                id: scrollView
                anchors.fill: parent
                clip: true

                ScrollBar.vertical: QScrollBar {
                    anchors.top: scrollView.top
                    anchors.right: scrollView.right
                    anchors.bottom: scrollView.bottom
                    policy: ScrollBar.AsNeeded
                }

                Flickable {
                    anchors.fill: parent
                    contentWidth: width
                    contentHeight: layout_column.height
                    clip: true

                    Column {
                        id: layout_column
                        spacing: 15
                        width: parent.width

                        QExpander {
                            id: qtExpander
                            headerText: "Qt LGPL 3.0"
                            Layout.fillWidth: true
                            implicitWidth: 400
                            contentHeight: 200
                            anchors.horizontalCenter: parent.horizontalCenter

                            Item {
                                anchors.fill: parent

                                Flickable {
                                    id: scrollview_qt
                                    anchors.fill: parent
                                    contentWidth: width
                                    contentHeight: text_qt_lgpl3.height + 5
                                    QScrollBar.vertical: QScrollBar {}

                                    QText {
                                        id: text_qt_lgpl3
                                        width: scrollview_qt.width
                                        wrapMode: Text.Wrap
                                        padding: 14
                                        text: fileReader.readFile("qrc:/qt/qml/src/legal/qt-lgpl-3.0.txt")
                                    }
                                }
                            }
                        }

                        QExpander {
                            id: qmlUnitExpander
                            headerText: "Qml Unit MIT"
                            Layout.fillWidth: true
                            implicitWidth: 400
                            contentHeight: 200
                            anchors.horizontalCenter: parent.horizontalCenter

                            Item {
                                anchors.fill: parent

                                Flickable {
                                    id: scrollview_qmlUnit
                                    anchors.fill: parent
                                    contentWidth: width
                                    contentHeight: text_qmlUnit_mit.contentHeight + 25
                                    QScrollBar.vertical: QScrollBar {}

                                    QText {
                                        id: text_qmlUnit_mit
                                        width: scrollview_qmlUnit.width
                                        wrapMode: Text.Wrap
                                        padding: 14
                                        text: fileReader.readFile("qrc:/qt/qml/src/legal/qml-unit-mit.txt")
                                    }
                                }
                            }
                        }

                        QExpander {
                            id: libsodiumExpander
                            headerText: "libsodium ISC"
                            Layout.fillWidth: true
                            implicitWidth: 400
                            contentHeight: 200
                            anchors.horizontalCenter: parent.horizontalCenter

                            Item {
                                anchors.fill: parent

                                Flickable {
                                    id: scrollview_libsodium
                                    anchors.fill: parent
                                    contentWidth: width
                                    contentHeight: text_libsodium_isc.contentHeight + 25
                                    QScrollBar.vertical: QScrollBar {}

                                    QText {
                                        id: text_libsodium_isc
                                        width: scrollview_libsodium.width
                                        wrapMode: Text.Wrap
                                        padding: 14
                                        text: fileReader.readFile("qrc:/qt/qml/src/legal/libsodium-isc.txt")
                                    }
                                }
                            }
                        }

                        QExpander {
                            id: assetsExpander
                            headerText: "Assets"
                            Layout.fillWidth: true
                            implicitWidth: 400
                            contentHeight: 200
                            anchors.horizontalCenter: parent.horizontalCenter

                            Item {
                                anchors.fill: parent

                                Flickable {
                                    id: scrollview_assets
                                    anchors.fill: parent
                                    contentWidth: width
                                    contentHeight: text_assets.contentHeight + 25
                                    QScrollBar.vertical: QScrollBar {}

                                    QText {
                                        id: text_assets
                                        width: scrollview_assets.width
                                        wrapMode: Text.Wrap
                                        padding: 14
                                        text: fileReader.readFile("qrc:/qt/qml/src/legal/assets.txt")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
