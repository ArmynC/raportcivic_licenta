import QtQuick
import QtQuick.Controls
import Component

Text {
    property color textColor: QTheme.fontPrimaryColor
    id:text
    color: textColor
    renderType: QTheme.nativeText ? Text.NativeRendering : Text.QtRendering
    font: QTextStyle.Body
}
