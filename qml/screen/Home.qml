import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import Component
import "../pane"
import "../board"

QScrollablePage {

    launchMode: QPageType.SingleTask
    animationEnabled: false
    header: Item {}

    ListModel {
        id: model_header
        ListElement {
            icon: "qrc:/qt/qml/src/assets/img/circle/c1.png"
            title: qsTr("Legea 544/2001")
            desc: qsTr("Cuprins legislativ")
            url: "https://legislatie.just.ro/Public/DetaliiDocument/31413"
            clicked: function (model) {
                Qt.openUrlExternally(model.url)
            }
        }
        ListElement {
            icon: "qrc:/qt/qml/src/assets/img/circle/c2.png"
            title: qsTr("OG. 27/2002")
            desc: qsTr("Continut reglementare consolidat")
            url: "https://legislatie.just.ro/Public/DetaliiDocument/196568"
            clicked: function (model) {
                Qt.openUrlExternally(model.url)
            }
        }
    }

    Item {
        Layout.fillWidth: true
        Layout.preferredHeight: 320
        Image {
            id: bg
            fillMode: Image.PreserveAspectCrop
            anchors.fill: parent
            verticalAlignment: Qt.AlignTop
            sourceSize: Qt.size(960, 640)
            source: "qrc:/qt/qml/src/assets/img/waves_header.png"
        }
        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop {
                    position: 0.8
                    color: QTheme.dark ? Qt.rgba(0, 0, 0, 0) : Qt.rgba(1, 1, 1, 0)
                }
                GradientStop {
                    position: 1.0
                    color: QTheme.dark ? Qt.rgba(0, 0, 0, 1) : Qt.rgba(1, 1, 1, 1)
                }
            }
        }
        QText {
            text: qsTr("Centru RaportCivic")
            font: QTextStyle.TitleLarge
            anchors {
                top: parent.top
                left: parent.left
                topMargin: 20
                leftMargin: 20
            }
        }
        Component {
            id: com_gallery
            Item {
                id: control
                width: 220
                height: 240
                QShadow {
                    radius: 5
                    anchors.fill: item_content
                }
                QClip {
                    id: item_content
                    radius: [5, 5, 5, 5]
                    width: 200
                    height: 220
                    anchors.centerIn: parent
                    QAcrylic {
                        anchors.fill: parent
                        tintColor: QTheme.dark ? Qt.rgba(0, 0, 0, 1) : Qt.rgba(1, 1, 1, 1)
                        target: bg
                        tintOpacity: QTheme.dark ? 0.8 : 0.9
                        blurRadius: 40
                        targetRect: Qt.rect(list.x - list.contentX + 10 + (control.width) * index, list.y + 10, width, height)
                    }
                    Rectangle {
                        anchors.fill: parent
                        radius: 5
                        color: QTheme.itemHoverColor
                        visible: item_mouse.containsMouse
                    }
                    Rectangle {
                        anchors.fill: parent
                        radius: 5
                        color: Qt.rgba(0, 0, 0, 0.0)
                        visible: !item_mouse.containsMouse
                    }
                    ColumnLayout {
                        Image {
                            Layout.topMargin: 20
                            Layout.leftMargin: 20
                            Layout.preferredWidth: 50
                            Layout.preferredHeight: 50
                            source: model.icon
                        }
                        QText {
                            text: model.title
                            font: QTextStyle.Body
                            Layout.topMargin: 20
                            Layout.leftMargin: 20
                        }
                        QText {
                            text: model.desc
                            Layout.topMargin: 5
                            Layout.preferredWidth: 160
                            Layout.leftMargin: 20
                            color: QColors.Grey120
                            font.pixelSize: 12
                            font.family: QTextStyle.family
                            wrapMode: Text.WrapAnywhere
                        }
                    }
                    QIcon {
                        iconSource: FluentIcons.OpenInNewWindow
                        iconSize: 15
                        anchors {
                            bottom: parent.bottom
                            right: parent.right
                            rightMargin: 10
                            bottomMargin: 10
                        }
                    }
                    MouseArea {
                        id: item_mouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onWheel: wheel => {
                                     if (wheel.angleDelta.y > 0)
                                     scrollbar_header.decrease()
                                     else
                                     scrollbar_header.increase()
                                 }
                        onClicked: {
                            model.clicked(model)
                        }
                    }
                }
            }
        }

        ListView {
            id: list
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            orientation: ListView.Horizontal
            height: 240
            model: model_header
            header: Item {
                height: 10
                width: 10
            }
            footer: Item {
                height: 10
                width: 10
            }
            ScrollBar.horizontal: QScrollBar {
                id: scrollbar_header
            }
            clip: false
            delegate: com_gallery
        }
    }

    Component {
        id: com_item
        Item {
            property string desc: modelData.shortcut.desc
            width: 320
            height: 120
            QFrame {
                radius: 8
                width: 300
                height: 100
                anchors.centerIn: parent
                Rectangle {
                    anchors.fill: parent
                    radius: 8
                    color: {
                        if (item_mouse.containsMouse) {
                            return QTheme.itemHoverColor
                        }
                        return QTheme.itemNormalColor
                    }
                }
                Image {
                    id: item_icon
                    height: 40
                    width: 40
                    source: modelData.shortcut.image
                    anchors {
                        left: parent.left
                        leftMargin: 20
                        verticalCenter: parent.verticalCenter
                    }
                }
                QText {
                    id: item_title
                    text: modelData.title
                    font: QTextStyle.BodyStrong
                    anchors {
                        left: item_icon.right
                        leftMargin: 20
                        top: item_icon.top
                    }
                }
                QText {
                    id: item_desc
                    text: desc
                    color: QColors.Grey120
                    wrapMode: Text.WrapAnywhere
                    elide: Text.ElideRight
                    font: QTextStyle.Caption
                    maximumLineCount: 2
                    anchors {
                        left: item_title.left
                        right: parent.right
                        rightMargin: 20
                        top: item_title.bottom
                        topMargin: 5
                    }
                }

                Rectangle {
                    height: 12
                    width: 12
                    radius: 6
                    color: QTheme.primaryColor
                    anchors {
                        right: parent.right
                        top: parent.top
                        rightMargin: 14
                        topMargin: 14
                    }
                }

                MouseArea {
                    id: item_mouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        ItemsMain.startPageByItem(modelData)
                    }
                }
            }
        }
    }

    QText {
        text: qsTr("Scurtatura")
        font: QTextStyle.Subtitle
        Layout.topMargin: 20
        Layout.leftMargin: 20
    }

    GridView {
        Layout.fillWidth: true
        Layout.preferredHeight: contentHeight
        cellHeight: 120
        cellWidth: 320
        model: ItemsMain.getShortcuts()
        interactive: false
        delegate: com_item
    }

    ColumnLayout {
        QText {
            text:  qsTr("Scurtaturi utilizator")
            font: QTextStyle.Subtitle
            Layout.topMargin: 20
            Layout.leftMargin: 20
            visible: AccountManager.isLoggedIn
        }

        GridView {
            Layout.fillWidth: true
            Layout.preferredHeight: contentHeight
            cellHeight: 120
            cellWidth: 320
            interactive: false
            model: ItemsMain.getShortcutsUser()
            delegate: com_item
            visible: AccountManager.isLoggedIn
        }
    }
}
