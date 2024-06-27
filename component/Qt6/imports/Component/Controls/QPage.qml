import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import Component

Page {
    property int launchMode: QPageType.SingleTop
    property bool animationEnabled: QTheme.animationEnabled
    property string url : ""
    id: control
    StackView.onRemoved: destroy()
    padding: 5
    visible: false
    opacity: visible
    transform: Translate {
        y: control.visible ? 0 : 80
        Behavior on y{
            enabled: control.animationEnabled && QTheme.animationEnabled
            NumberAnimation{
                duration: 167
                easing.type: Easing.OutCubic
            }
        }
    }
    Behavior on opacity {
        enabled: control.animationEnabled && QTheme.animationEnabled
        NumberAnimation{
            duration: 83
        }
    }
    background: Item{}
    header: QLoader{
        sourceComponent: control.title === "" ? undefined : com_header
    }
    Component{
        id: com_header
        Item{
            implicitHeight: 40
            QText{
                id:text_title
                text: control.title
                font: QTextStyle.Title
                anchors{
                    left: parent.left
                    leftMargin: 5
                }
            }
        }
    }
    Component.onCompleted: {
        control.visible = true
    }
}
