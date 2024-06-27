import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import Component

Button {
    property bool disabled: false
    property string contentDescription: ""
    property color normalColor: QTheme.primaryColor
    property color hoverColor: QTheme.dark ? Qt.darker(normalColor,1.1) : Qt.lighter(normalColor,1.1)
    property color disableColor: QTheme.dark ? Qt.rgba(82/255,82/255,82/255,1) : Qt.rgba(199/255,199/255,199/255,1)
    property color pressedColor: QTheme.dark ? Qt.darker(normalColor,1.2) : Qt.lighter(normalColor,1.2)
    property color textColor: {
        if(QTheme.dark){
            if(!enabled){
                return Qt.rgba(173/255,173/255,173/255,1)
            }
            return Qt.rgba(0,0,0,1)
        }else{
            return Qt.rgba(1,1,1,1)
        }
    }
    Accessible.role: Accessible.Button
    Accessible.name: control.text
    Accessible.description: contentDescription
    Accessible.onPressAction: control.clicked()
    id: control
    enabled: !disabled
    focusPolicy:Qt.TabFocus
    font:QTextStyle.Body
    verticalPadding: 0
    horizontalPadding:12
    background: QControlBackground{
        implicitWidth: 30
        implicitHeight: 30
        radius: 4
        bottomMargin: enabled ? 2 : 0
        border.width: enabled ? 1 : 0
        border.color: enabled ? Qt.darker(control.normalColor,1.2) : disableColor
        color:{
            if(!enabled){
                return disableColor
            }
            if(pressed){
                return pressedColor
            }
            return hovered ? hoverColor :normalColor
        }
        QFocusRectangle{
            visible: control.visualFocus
            radius:4
        }
    }
    contentItem: QText {
        text: control.text
        font: control.font
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: control.textColor
    }
}
