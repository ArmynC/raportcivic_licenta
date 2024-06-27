import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Templates as T
import Component

T.ItemDelegate {
    id: control
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset, implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset, implicitContentHeight + topPadding + bottomPadding, implicitIndicatorHeight + topPadding + bottomPadding)
    padding: 0
    verticalPadding: 8
    horizontalPadding: 10
    icon.color: control.palette.text
    contentItem: QText {
        text: control.text
        font: control.font
        color: {
            if (control.down) {
                return QTheme.dark ? QColors.Grey80 : QColors.Grey120
            }
            return QTheme.dark ? QColors.White : QColors.Grey220
        }
        wrapMode: Text.Wrap // text wrap, useful for combobox
    }
    background: Rectangle {
        implicitWidth: 100
        implicitHeight: 30
        color: {
            if (QTheme.dark) {
                return Qt.rgba(1, 1, 1, 0.05)
            } else {
                return Qt.rgba(0, 0, 0, 0.05)
            }
        }
        visible: control.down || control.highlighted || control.visualFocus
    }
}
