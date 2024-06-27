pragma Singleton

import QtQuick
import Component

// manage shared data and state of the app for multiple components

QtObject {
    property int displayMode: QNavigationViewType.Auto
}
