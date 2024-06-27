import QtQuick
import QtQuick.Controls
import Component

QMenu{
    property string cutText : qsTr("Taie")
    property string copyText : qsTr("Copiaza")
    property string pasteText : qsTr("Lipeste")
    property string selectAllText : qsTr("Selecteaza totul")
    property var inputItem
    id:menu
    animationEnabled: false
    width: 120
    focus: false
    onVisibleChanged: {
        if(inputItem){
            inputItem.forceActiveFocus()
        }
    }
    Connections{
        target: {
            if(inputItem){
                return inputItem
            }
            return null
        }
        function onTextChanged() {
            menu.close()
        }
        function onActiveFocusChanged() {
            if(!inputItem.activeFocus){
                menu.close()
            }
        }
    }
    QIconButton{
        display: Button.TextOnly
        text:cutText
        focus: false
        padding: 0
        height: visible ? 36 : 0
        visible: {
            if(inputItem){
                return inputItem.selectedText !== "" && !inputItem.readOnly
            }
            return false
        }
        onClicked: {
            inputItem.cut()
            menu.close()
        }
    }
    QIconButton{
        display: Button.TextOnly
        text:copyText
        focus: false
        padding: 0
        height: visible ? 36 : 0
        visible: {
            if(inputItem){
                return inputItem.selectedText !== ""
            }
            return false
        }
        onClicked: {
            inputItem.copy()
            menu.close()
        }
    }
    QIconButton{
        display: Button.TextOnly
        text:pasteText
        focus: false
        padding: 0
        visible: {
            if(inputItem){
                return !inputItem.readOnly
            }
            return false
        }
        height: visible ? 36 : 0
        onClicked: {
            inputItem.paste()
            menu.close()
        }
    }
    QIconButton{
        display: Button.TextOnly
        text:selectAllText
        focus: false
        padding: 0
        height: visible ? 36 : 0
        visible: {
            if(inputItem){
                return inputItem.text !== ""
            }
            return false
        }
        onClicked: {
            inputItem.selectAll()
            menu.close()
        }
    }
}
