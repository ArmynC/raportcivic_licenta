import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import Component
import "../board"

QScrollablePage {

    id: root
    property var colorData: [QColors.Yellow, QColors.Orange, QColors.Red, QColors.Magenta, QColors.Purple, QColors.Blue, QColors.Teal, QColors.Green]
    title: qsTr("Setari")

    QFrame {
        Layout.fillWidth: true
        Layout.topMargin: 20
        Layout.preferredHeight: 270
        padding: 10

        ColumnLayout {
            spacing: 0
            anchors {
                left: parent.left
            }
            QText {
                text: qsTr("Stil aplicatie")
                Layout.topMargin: 10
            }
            RowLayout {
                Layout.topMargin: 5
                Repeater {
                    model: root.colorData
                    delegate: Rectangle {
                        width: 42
                        height: 42
                        radius: 4
                        color: mouse_item.containsMouse ? Qt.lighter(modelData.normal, 1.1) : modelData.normal
                        border.color: modelData.darker
                        QIcon {
                            anchors.centerIn: parent
                            iconSource: FluentIcons.AcceptMedium
                            iconSize: 15
                            visible: modelData === QTheme.accentColor
                            color: QTheme.dark ? Qt.rgba(0, 0, 0, 1) : Qt.rgba(1, 1, 1, 1)
                        }
                        MouseArea {
                            id: mouse_item
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                QTheme.accentColor = modelData
                            }
                        }
                    }
                }
            }
            Row {
                Layout.topMargin: 10
                spacing: 10
                QText {
                    text: qsTr("Paleta de culori")
                    anchors.verticalCenter: parent.verticalCenter
                }
                QColorPicker {
                    id: color_picker
                    current: QTheme.accentColor.normal
                    onAccepted: {
                        QTheme.accentColor = QColors.createAccentColor(current)
                    }
                    QIcon {
                        anchors.centerIn: parent
                        iconSource: FluentIcons.AcceptMedium
                        iconSize: 15
                        visible: {
                            for (var i = 0; i < root.colorData.length; i++) {
                                if (root.colorData[i] === QTheme.accentColor) {
                                    return false
                                }
                            }
                            return true
                        }
                        color: QTheme.dark ? Qt.rgba(0, 0, 0, 1) : Qt.rgba(1, 1, 1, 1)
                    }
                }
            }
            QText {
                text: qsTr("Font nativ")
                Layout.topMargin: 20
            }
            QToggleSwitch {
                Layout.topMargin: 5
                checked: QTheme.nativeText
                onClicked: {
                    QTheme.nativeText = !QTheme.nativeText
                }
            }
            QText {
                text: qsTr("Animatie deschidere")
                Layout.topMargin: 20
            }
            QToggleSwitch {
                Layout.topMargin: 5
                checked: QTheme.animationEnabled
                onClicked: {
                    QTheme.animationEnabled = !QTheme.animationEnabled
                }
            }
        }
    }

    QFrame {
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 128
        padding: 10

        ColumnLayout {
            spacing: 5
            anchors {
                top: parent.top
                left: parent.left
            }
            QText {
                text: qsTr("Mod intunecat")
                font: QTextStyle.BodyStrong
                Layout.bottomMargin: 4
            }
            Repeater {
                model: [{
                        "title": qsTr("Nativ"),
                        "mode": QThemeType.System
                    }, {
                        "title": qsTr("Luminos"),
                        "mode": QThemeType.Light
                    }, {
                        "title": qsTr("Intunecat"),
                        "mode": QThemeType.Dark
                    }]
                delegate: QRadioButton {
                    checked: QTheme.darkMode === modelData.mode
                    text: modelData.title
                    clickListener: function () {
                        QTheme.darkMode = modelData.mode
                    }
                }
            }
        }
    }

    QFrame {
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 100
        padding: 10

        ColumnLayout {
            anchors.fill: parent
            spacing: 10

            QCheckBox {
                id: stateSystemBar
                text: qsTr("Bara Integrata")
                checked: !QApp.useSystemAppBar
                onClicked: {
                    QApp.useSystemAppBar = !checked
                    dialog_restart.open()
                }
            }

            RowLayout {
                spacing: 10
                Layout.leftMargin: 20

                QCheckBox {
                    text: qsTr("Incadrare bara")
                    checked: window.fitsAppBarWindows
                    enabled: stateSystemBar.checked
                    Layout.alignment: Qt.AlignVCenter
                    onClicked: {
                        window.fitsAppBarWindows = !window.fitsAppBarWindows
                    }
                }
            }
        }
    }

    QContentDialog {
        id: dialog_restart
        title: qsTr("Informare")
        message: qsTr("Este necesara reponirea aplicatiei. Continui?")
        buttonFlags: QContentDialogType.NegativeButton | QContentDialogType.PositiveButton
        negativeText: qsTr("Renuntare")
        positiveText: qsTr("Repornire")
        onPositiveClicked: {
            QRouter.exit(931)
        }
        onNegativeClicked: {
            stateSystemBar.checked = QApp.useSystemAppBar
            QApp.useSystemAppBar = !stateSystemBar.checked
        }
    }

    QFrame {
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 160
        padding: 10

        ColumnLayout {
            spacing: 5
            anchors {
                top: parent.top
                left: parent.left
            }
            QText {
                text: qsTr("Mod afisare bara navigare")
                font: QTextStyle.BodyStrong
                Layout.bottomMargin: 4
            }
            Repeater {
                model: [{
                        "title": qsTr("Deschis"),
                        "mode": QNavigationViewType.Open
                    }, {
                        "title": qsTr("Compact"),
                        "mode": QNavigationViewType.Compact
                    }, {
                        "title": qsTr("Minimal"),
                        "mode": QNavigationViewType.Minimal
                    }, {
                        "title": qsTr("Automat"),
                        "mode": QNavigationViewType.Auto
                    }]
                delegate: QRadioButton {
                    text: modelData.title
                    checked: SharedState.displayMode === modelData.mode
                    clickListener: function () {
                        SharedState.displayMode = modelData.mode
                    }
                }
            }
        }
    }

    ListModel {
        id: model_language
        ListElement {
            name: "en"
        }
        ListElement {
            name: "ro"
        }
    }

    QFrame {
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 80
        padding: 10

        ColumnLayout {
            spacing: 10
            anchors {
                top: parent.top
                left: parent.left
            }
            QText {
                text: qsTr("Limba")
                font: QTextStyle.BodyStrong
                Layout.bottomMargin: 4
            }
            Flow {
                spacing: 5
                Repeater {
                    model: TranslateHelper.languages
                    delegate: QRadioButton {
                        checked: TranslateHelper.current === modelData
                        text: modelData
                        clickListener: function () {
                            TranslateHelper.current = modelData
                            dialog_restart.open()
                        }
                    }
                }
            }
        }
    }

    QEvent {
        name: "checkUpdateFinish"
        onTriggered: {
            btn_checkupdate.loading = false
        }
    }

    /*
    QFrame {
        Layout.fillWidth: true
        Layout.topMargin: 20
        Layout.preferredHeight: 60
        padding: 10
        Row {
            spacing: 20
            anchors.verticalCenter: parent.verticalCenter
            QText {
                text: "%1 v%2".arg(qsTr("Versiune")).arg(AppVersion.version)
                font: QTextStyle.Body
                anchors.verticalCenter: parent.verticalCenter
            }
            QLoadingButton {
                id: btn_checkupdate
                text: qsTr("Verificare actualizari")
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    loading = true
                    QEventBus.post("checkUpdate")
                }
            }
        }
    }
    */
}
