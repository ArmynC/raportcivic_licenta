import QtQuick
import QtQuick.Controls
import Component

TextEdit {
    property color textColor: QTheme.dark ? QColors.White : QColors.Grey220
    id:control
    color: textColor
    readOnly: true
    activeFocusOnTab: false
    activeFocusOnPress: false
    renderType: QTheme.nativeText ? Text.NativeRendering : Text.QtRendering
    padding: 0
    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    selectByMouse: true
    selectedTextColor: color
    bottomPadding: 0
    selectionColor: QTools.withOpacity(QTheme.primaryColor,0.5)
    font:QTextStyle.Body
    onSelectedTextChanged: {
        control.forceActiveFocus()
    }
    MouseArea{
        anchors.fill: parent
        cursorShape: Qt.IBeamCursor
        acceptedButtons: Qt.RightButton
        onClicked: control.echoMode !== TextInput.Password && menu.popup()
    }
    QTextBoxMenu{
        id:menu
        inputItem: control
    }
}
