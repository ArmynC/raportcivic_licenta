import QtQuick
import QtQuick.Controls
import Component

QTextBox {
    property var items: []
    property string emptyText: qsTr("Nu au fost gasite rezultate")
    property int autoSuggestBoxReplacement: FluentIcons.Search
    property var filter: function (item) {
        if (item.title.indexOf(control.text) !== -1) {
            return true
        }
        return false
    }
    signal itemClicked(var data)
    id: control
    Component.onCompleted: {
        d.loadData()
    }
    Item {
        id: d
        property bool flagVisible: true
        property var window: Window.window
        function handleClick(modelData) {
            control_popup.visible = false
            control.itemClicked(modelData)
            control.updateText(modelData.title)
        }
        function loadData() {
            var result = []
            if (items == null) {
                list_view.model = result
                return
            }
            items.map(function (item) {
                if (control.filter(item)) {
                    result.push(item)
                }
            })
            list_view.model = result
        }
    }
    onActiveFocusChanged: {
        if (!activeFocus) {
            control_popup.visible = false
        }
    }
    Popup {
        id: control_popup
        y: control.height
        focus: false
        padding: 0
        enter: Transition {
            NumberAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: QTheme.animationEnabled ? 83 : 0
            }
        }
        contentItem: QRectangle {
            radius: [4, 4, 4, 4]
            QShadow {
                radius: 4
            }
            color: QTheme.dark ? Qt.rgba(51 / 255, 48 / 255, 48 / 255, 1) : Qt.rgba(248 / 255, 250 / 255, 253 / 255, 1)
            ListView {
                id: list_view
                anchors.fill: parent
                clip: true
                boundsBehavior: ListView.StopAtBounds
                ScrollBar.vertical: QScrollBar {}
                header: Item {
                    width: control.width
                    height: visible ? 38 : 0
                    visible: list_view.count === 0
                    QText {
                        text: emptyText
                        anchors {
                            verticalCenter: parent.verticalCenter
                            left: parent.left
                            leftMargin: 10
                        }
                    }
                }
                delegate: QControl {
                    id: item_control
                    height: 38
                    width: control.width
                    onClicked: {
                        d.handleClick(modelData)
                    }
                    background: Rectangle {
                        QFocusRectangle {
                            visible: item_control.activeFocus
                            radius: 4
                        }
                        color: {
                            if (hovered) {
                                return QTheme.dark ? Qt.rgba(63 / 255, 60 / 255, 61 / 255, 1) : Qt.rgba(237 / 255, 237 / 255, 242 / 255, 1)
                            }
                            return QTheme.dark ? Qt.rgba(51 / 255, 48 / 255, 48 / 255, 1) : Qt.rgba(0, 0, 0, 0)
                        }
                    }
                    contentItem: QText {
                        text: modelData.title
                        leftPadding: 10
                        rightPadding: 10
                        verticalAlignment: Qt.AlignVCenter
                    }
                }
            }
        }
        background: Item {
            id: container
            implicitWidth: control.width
            implicitHeight: 38 * Math.min(Math.max(list_view.count, 1), 8)
        }
    }
    onTextChanged: {
        d.loadData()
        if (d.flagVisible) {
            var pos = control.mapToItem(null, 0, 0)
            if (d.window.height > pos.y + control.height + container.implicitHeight) {
                control_popup.y = control.height
            } else if (pos.y > container.implicitHeight) {
                control_popup.y = -container.implicitHeight
            } else {
                control_popup.y = d.window.height - (pos.y + container.implicitHeight)
            }
            control_popup.visible = true
        }
    }
    function updateText(text) {
        d.flagVisible = false
        control.text = text
        d.flagVisible = true
    }
}
