import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Layouts
import Component
import module

Rectangle {
    property string title: ""
    property string darkText: qsTr("Intunecat")
    property string lightText: qsTr("Luminat")
    property string minimizeText: qsTr("Minimizare")
    property string restoreText: qsTr("Restabilire")
    property string maximizeText: qsTr("Maximizare")
    property string closeText: qsTr("Inchide")
    property string stayTopText: qsTr("Fixare fereastra")
    property string stayTopCancelText: qsTr("Fixare anulata")
    property color textColor: QTheme.dark ? "#FFFFFF" : "#000000"
    property color minimizeNormalColor: QTheme.itemNormalColor
    property color minimizeHoverColor: QTheme.itemHoverColor
    property color minimizePressColor: QTheme.itemPressColor
    property color maximizeNormalColor: QTheme.itemNormalColor
    property color maximizeHoverColor: QTheme.itemHoverColor
    property color maximizePressColor: QTheme.itemPressColor
    property color closeNormalColor: Qt.rgba(0, 0, 0, 0)
    property color closeHoverColor: Qt.rgba(251 / 255, 115 / 255, 115 / 255, 1)
    property color closePressColor: Qt.rgba(251 / 255, 115 / 255, 115 / 255, 0.8)
    property bool showAccount: false
    property bool showDark: false
    property bool showClose: true
    property bool showMinimize: true
    property bool showMaximize: true
    property bool showStayTop: true
    property bool titleVisible: true
    property url icon
    property int iconSize: 20
    property bool isMac: QTools.isMacos()
    property color borerlessColor: QTheme.primaryColor
    property alias buttonStayTop: btn_stay_top
    property alias buttonMinimize: btn_minimize
    property alias buttonMaximize: btn_maximize
    property alias buttonClose: btn_close
    property alias buttonDark: btn_dark
    property alias layoutMacosButtons: layout_macos_buttons
    property alias layoutStandardbuttons: layout_standard_buttons

    property var maxClickListener: function () {
        if (QTools.isMacos()) {
            if (d.win.visibility === Window.FullScreen)
                d.win.showNormal()
            else
                d.win.showFullScreen()
        } else {
            if (d.win.visibility === Window.Maximized)
                d.win.showNormal()
            else
                d.win.showMaximized()
            d.hoverMaxBtn = false
        }
    }
    property var minClickListener: function () {
        if (d.win.transientParent !== null) {
            d.win.transientParent.showMinimized()
        } else {
            d.win.showMinimized()
        }
    }
    property var closeClickListener: function () {
        d.win.close()
    }

    property QMenu accountMenuClicked: QMenu {
        width: 200

        QMenuItem {
            contentItem: QText {
                text: AccountManager.isLoggedIn ? AccountManager.userEmail : qsTr("Mod vizitator")
                font.bold: AccountManager.isLoggedIn // bold the email
                font.weight: AccountManager.isLoggedIn ? Font.Bold : Font.DemiBold // semi-thick text for guest mode
                color: AccountManager.isLoggedIn ? control.textColor : Qt.rgba(0.5, 0.5, 0.5, 1) // unactivated gray text
                elide: Text.ElideRight // handle long text
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.NoWrap
                anchors.centerIn: parent
            }
            enabled: false
        }

        QMenuItem {
            text: AccountManager.isLoggedIn ? qsTr("Setari cont") : qsTr("Conectare")
            onClicked: {
                if (AccountManager.isLoggedIn) {
                    QmlBridge.accountSettings()
                } else {
                    QRouter.navigate("/accountContent")
                }
            }
        }

        QMenuItem {
            text: qsTr("Deconectare")
            visible: AccountManager.isLoggedIn
            onClicked: {
                QmlBridge.logout()
                AccountManager.logoutAccount()
            }
        }

        // initial position of account menu
        function updateMenuPosition() {
            accountMenuClicked.x = accountButton.mapToItem(accountButton.Window.contentItem, 0, accountButton.height).x
            accountMenuClicked.y = accountButton.mapToItem(accountButton.Window.contentItem, 0, accountButton.height + 5).y
        }

        // window resize adjust
        Connections {
            target: accountButton.Window
            function onWidthChanged() {
                accountMenuClicked.x = accountButton.mapToItem(accountButton.Window.contentItem, 0, accountButton.height).x
            }
            function onHeightChanged() {
                accountMenuClicked.y = accountButton.mapToItem(accountButton.Window.contentItem, 0, accountButton.height + 5).y
            }
        }
    }

    property var stayTopClickListener: function () {
        if (d.win instanceof QWindow) {
            d.win.stayTop = !d.win.stayTop
        }
    }

    property var darkClickListener: function () {
        if (QTheme.dark) {
            QTheme.darkMode = QThemeType.Light
        } else {
            QTheme.darkMode = QThemeType.Dark
        }
    }

    id: control
    color: Qt.rgba(0, 0, 0, 0)
    height: visible ? 30 : 0
    opacity: visible
    z: 65535
    Item {
        id: d
        property var hitTestList: []
        property bool hoverMaxBtn: false
        property var win: Window.window
        property bool stayTop: {
            if (d.win instanceof QWindow) {
                return d.win.stayTop
            }
            return false
        }
        property bool isRestore: win && Window.Maximized === win.visibility
        property bool resizable: win && !(win.height === win.maximumHeight && win.height === win.minimumHeight && win.width === win.maximumWidth && win.width === win.minimumWidth)
        function containsPointToItem(point, item) {
            var pos = item.mapToGlobal(0, 0)
            var rect = Qt.rect(pos.x, pos.y, item.width, item.height)
            if (point.x > rect.x && point.x < (rect.x + rect.width) && point.y > rect.y && point.y < (rect.y + rect.height)) {
                return true
            }
            return false
        }
    }

    Row {
        anchors {
            verticalCenter: parent.verticalCenter
            left: isMac ? undefined : parent.left
            leftMargin: isMac ? undefined : 10
            horizontalCenter: isMac ? parent.horizontalCenter : undefined
        }
        spacing: 10
        Image {
            width: control.iconSize
            height: control.iconSize
            visible: status === Image.Ready ? true : false
            source: control.icon
            anchors.verticalCenter: parent.verticalCenter
        }
        QText {
            text: title
            visible: control.titleVisible
            color: control.textColor
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Component {
        id: com_macos_buttons
        RowLayout {
            QImageButton {
                Layout.preferredHeight: 12
                Layout.preferredWidth: 12
                normalImage: "../Image/btn_close_normal.png"
                hoveredImage: "../Image/btn_close_hovered.png"
                pushedImage: "../Image/btn_close_pushed.png"
                visible: showClose
                onClicked: closeClickListener()
            }
            QImageButton {
                Layout.preferredHeight: 12
                Layout.preferredWidth: 12
                normalImage: "../Image/btn_min_normal.png"
                hoveredImage: "../Image/btn_min_hovered.png"
                pushedImage: "../Image/btn_min_pushed.png"
                onClicked: minClickListener()
                visible: showMinimize
            }
            QImageButton {
                Layout.preferredHeight: 12
                Layout.preferredWidth: 12
                normalImage: "../Image/btn_max_normal.png"
                hoveredImage: "../Image/btn_max_hovered.png"
                pushedImage: "../Image/btn_max_pushed.png"
                onClicked: maxClickListener()
                visible: d.resizable && showMaximize
            }
        }
    }

    RowLayout {
        id: layout_standard_buttons
        height: parent.height
        anchors.right: parent.right
        spacing: 0
        QIconButton {
            id: accountButton
            Layout.preferredWidth: 40
            Layout.preferredHeight: 30
            padding: 0
            verticalPadding: 0
            horizontalPadding: 0
            iconSource: FluentIcons.Accounts
            Layout.alignment: Qt.AlignVCenter
            iconSize: 15
            visible: showAccount
            radius: 0
            iconColor: control.textColor
            hoverEnabled: true
            onClicked: {
                accountMenuClicked.updateMenuPosition()
                accountMenuClicked.open()
            }
        }
        QIconButton {
            id: btn_dark
            Layout.preferredWidth: 40
            Layout.preferredHeight: 30
            padding: 0
            verticalPadding: 0
            horizontalPadding: 0
            rightPadding: 2
            iconSource: QTheme.dark ? FluentIcons.Brightness : FluentIcons.QuietHours
            Layout.alignment: Qt.AlignVCenter
            iconSize: 15
            visible: showDark
            text: QTheme.dark ? control.lightText : control.darkText
            radius: 0
            iconColor: control.textColor
            onClicked: () => darkClickListener(btn_dark)
        }
        QIconButton {
            id: btn_stay_top
            Layout.preferredWidth: 40
            Layout.preferredHeight: 30
            padding: 0
            verticalPadding: 0
            horizontalPadding: 0
            iconSource: FluentIcons.Pinned
            Layout.alignment: Qt.AlignVCenter
            iconSize: 14
            visible: {
                if (!(d.win instanceof QWindow)) {
                    return false
                }
                return showStayTop
            }
            text: d.stayTop ? control.stayTopCancelText : control.stayTopText
            radius: 0
            iconColor: d.stayTop ? QTheme.primaryColor : control.textColor
            onClicked: stayTopClickListener()
        }
        QIconButton {
            id: btn_minimize
            Layout.preferredWidth: 40
            Layout.preferredHeight: 30
            padding: 0
            verticalPadding: 0
            horizontalPadding: 0
            iconSource: FluentIcons.ChromeMinimize
            Layout.alignment: Qt.AlignVCenter
            iconSize: 11
            text: minimizeText
            radius: 0
            visible: !isMac && showMinimize
            iconColor: control.textColor
            color: {
                if (pressed) {
                    return minimizePressColor
                }
                return hovered ? minimizeHoverColor : minimizeNormalColor
            }
            onClicked: minClickListener()
        }
        QIconButton {
            id: btn_maximize
            property bool hover: btn_maximize.hovered
            Layout.preferredWidth: 40
            Layout.preferredHeight: 30
            padding: 0
            verticalPadding: 0
            horizontalPadding: 0
            iconSource: d.isRestore ? FluentIcons.ChromeRestore : FluentIcons.ChromeMaximize
            color: {
                if (down) {
                    return maximizePressColor
                }
                return btn_maximize.hover ? maximizeHoverColor : maximizeNormalColor
            }
            Layout.alignment: Qt.AlignVCenter
            visible: d.resizable && !isMac && showMaximize
            radius: 0
            iconColor: control.textColor
            text: d.isRestore ? restoreText : maximizeText
            iconSize: 11
            onClicked: maxClickListener()
        }
        QIconButton {
            id: btn_close
            Layout.preferredWidth: 40
            Layout.preferredHeight: 30
            padding: 0
            verticalPadding: 0
            horizontalPadding: 0
            iconSource: FluentIcons.ChromeClose
            Layout.alignment: Qt.AlignVCenter
            text: closeText
            visible: !isMac && showClose
            radius: 0
            iconSize: 10
            iconColor: hovered ? Qt.rgba(1, 1, 1, 1) : control.textColor
            color: {
                if (pressed) {
                    return closePressColor
                }
                return hovered ? closeHoverColor : closeNormalColor
            }
            onClicked: closeClickListener()
        }
    }

    QLoader {
        id: layout_macos_buttons
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: 10
        }
        sourceComponent: isMac ? com_macos_buttons : undefined
    }
}
