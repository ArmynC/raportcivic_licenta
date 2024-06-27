import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Component
import module

QScrollablePage {
    title: qsTr("Text generat")
    Component {
        id: com_page
        Rectangle {
            anchors.fill: parent
            color: "white"
            ScrollView {
                anchors.fill: parent
                TextArea {
                    id: textArea
                    width: parent.width
                    text: ReportBridge.reportText
                    readOnly: true
                    selectByMouse: true
                    wrapMode: TextArea.Wrap
                }
            }
        }
    }

    function newTab() {
        tab_view.setTabList([tab_view.createTab("", qsTr("Sesizare"), com_page)])
    }

    Component.onCompleted: {
        newTab()
        tab_view.addButtonVisibility = false
    }

    function toggleAddButton() {
        tab_view.addButtonVisibility = !tab_view.addButtonVisibility
    }

    QFrame {
        Layout.fillWidth: true
        Layout.topMargin: 15
        Layout.preferredHeight: 400
        padding: 10
        QTabView {
            id: tab_view
            property int tabWidthBehavior: QTabViewType.Equal
            property int closeButtonVisibility: QTabViewType.Never
            property int itemWidth: 146
            property bool addButtonVisibility: false
        }
    }
}
