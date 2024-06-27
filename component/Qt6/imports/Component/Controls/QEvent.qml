import QtQuick
import QtQuick.Controls
import Component

QtObject {
    id:control
    property string name
    signal triggered(var data)
    Component.onCompleted: {
        QEventBus.register(control)
    }
    Component.onDestruction: {
        QEventBus.unregister(control)
    }
}
