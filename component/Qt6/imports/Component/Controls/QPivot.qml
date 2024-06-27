import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import Component

Page {
    default property alias content: d.children
    property alias currentIndex: nav_list.currentIndex
    property color textNormalColor: QTheme.dark ? QColors.Grey120 : QColors.Grey120
    property color textHoverColor: QTheme.dark ? QColors.Grey10 : QColors.Black
    property int textSpacing: 10
    property int headerSpacing: 20
    property int headerHeight: 40
    id:control
    width: 400
    height: 300
    font: QTextStyle.Title
    implicitHeight: height
    implicitWidth: width
    QObject{
        id:d
        property int tabY: control.headerHeight/2+control.font.pixelSize/2 + 3
    }
    background:Item{}
    header:ListView{
        id:nav_list
        implicitHeight: control.headerHeight
        implicitWidth: control.width
        model:d.children
        spacing: control.headerSpacing
        interactive: false
        orientation: ListView.Horizontal
        highlightMoveDuration: QTheme.animationEnabled ? 167 : 0
        highlight: Item{
            clip: true
            Rectangle{
                height: 3
                radius: 1.5
                color: QTheme.primaryColor
                width: nav_list.currentItem ? nav_list.currentItem.width : 0
                y:d.tabY
                Behavior on width {
                    enabled: QTheme.animationEnabled
                    NumberAnimation{
                        duration: 167
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }
        delegate: Button{
            id:item_button
            width: item_title.width
            height: nav_list.height
            focusPolicy:Qt.TabFocus
            background:Item{
                QFocusRectangle{
                    anchors.margins: -4
                    visible: item_button.activeFocus
                    radius:4
                }
            }
            contentItem: Item{
                QText {
                    id:item_title
                    text: modelData.title
                    anchors.centerIn: parent
                    font: control.font
                    color: {
                        if(item_button.hovered)
                            return textHoverColor
                        return textNormalColor
                    }
                }
            }
            onClicked: {
                nav_list.currentIndex = index
            }
        }
    }
    Item{
        id:container
        anchors.fill: parent
        Repeater{
            model:d.children
            QLoader{
                property var argument: modelData.argument
                anchors.fill: parent
                sourceComponent: modelData.contentItem
                visible: nav_list.currentIndex === index
            }
        }
    }
}
