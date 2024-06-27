pragma Singleton

import QtQuick
import Component

QObject {

    property var navigationView

    id: footer_items

    QPaneItemSeparator {}

    QPaneItem {
        title: qsTr("Despre")
        icon: FluentIcons.Contact
        onTapListener: function () {
            QRouter.navigate("/about")
        }
    }

    QPaneItem {
        title: qsTr("Setari")
        icon: FluentIcons.Settings
        url: "qrc:/qt/qml/src/qml/screen/Settings.qml"
        onTap: {
            navigationView.push(url)
        }
    }
}
