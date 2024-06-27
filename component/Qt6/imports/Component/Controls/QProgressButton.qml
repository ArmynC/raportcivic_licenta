import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import Component

QButton {
    property real progress
    QtObject{
        id:d
        property bool checked: (Number(rect_back.height) === Number(background.height)) && (progress === 1)
    }
    id: control
    property color normalColor: {
        if(d.checked){
            return QTheme.primaryColor
        }else{
            return QTheme.dark ? Qt.rgba(62/255,62/255,62/255,1) : Qt.rgba(254/255,254/255,254/255,1)
        }
    }
    property color hoverColor: {
        if(d.checked){
            return QTheme.dark ? Qt.darker(normalColor,1.1) : Qt.lighter(normalColor,1.1)
        }else{
            return QTheme.dark ? Qt.rgba(68/255,68/255,68/255,1) : Qt.rgba(246/255,246/255,246/255,1)
        }
    }
    property color disableColor: {
        if(d.checked){
            return QTheme.dark ? Qt.rgba(82/255,82/255,82/255,1) : Qt.rgba(199/255,199/255,199/255,1)
        }else{
            return QTheme.dark ? Qt.rgba(59/255,59/255,59/255,1) : Qt.rgba(244/255,244/255,244/255,1)
        }
    }
    property color pressedColor: QTheme.dark ? Qt.darker(normalColor,1.2) : Qt.lighter(normalColor,1.2)
    background: QControlBackground{
        implicitWidth: 30
        implicitHeight: 30
        radius: 4
        border.color: QTheme.dark ? Qt.rgba(48/255,48/255,48/255,1) : Qt.rgba(188/255,188/255,188/255,1)
        border.width: d.checked ? 0 : 1
        color:{
            if(!enabled){
                return disableColor
            }
            if(d.checked){
                if(pressed){
                    return pressedColor
                }
            }
            return hovered ? hoverColor :normalColor
        }
        QClip{
            anchors.fill: parent
            radius: [4,4,4,4]
            Rectangle{
                id:rect_back
                width: parent.width  * control.progress
                height: control.progress === 1 ? background.height : 3
                visible: !d.checked
                color: QTheme.primaryColor
                anchors.bottom: parent.bottom
                Behavior on height{
                    enabled: control.progress !== 0
                    SequentialAnimation {
                        PauseAnimation {
                            duration: QTheme.animationEnabled ? 167 : 0
                        }
                        NumberAnimation{
                            duration: QTheme.animationEnabled ? 167 : 0
                            from: 3
                            to: background.height
                        }
                    }
                }
                Behavior on width{
                    NumberAnimation{
                        duration: 167
                    }
                }
            }
        }
        QFocusRectangle{
            visible: control.activeFocus
            radius:4
        }
    }
    contentItem: QText {
        text: control.text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: {
            if(d.checked){
                if(QTheme.dark){
                    if(!enabled){
                        return Qt.rgba(173/255,173/255,173/255,1)
                    }
                    return Qt.rgba(0,0,0,1)
                }else{
                    return Qt.rgba(1,1,1,1)
                }
            }else{
                if(QTheme.dark){
                    if(!enabled){
                        return Qt.rgba(131/255,131/255,131/255,1)
                    }
                    if(!d.checked){
                        if(pressed){
                            return Qt.rgba(162/255,162/255,162/255,1)
                        }
                    }
                    return Qt.rgba(1,1,1,1)
                }else{
                    if(!enabled){
                        return Qt.rgba(160/255,160/255,160/255,1)
                    }
                    if(!d.checked){
                        if(pressed){
                            return Qt.rgba(96/255,96/255,96/255,1)
                        }
                    }
                    return Qt.rgba(0,0,0,1)
                }
            }
        }
    }
}
