import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.platform
import Component
import module
import "../board"

QWindow {

    id: window
    title: "RaportCivic" // initial, non-integrated topbar
    width: 1000
    height: 680
    minimumWidth: 520
    minimumHeight: 200
    launchMode: QWindowType.SingleTask
    fitsAppBarWindows: true
    appBar: QAppBar {
        width: window.width
        height: 30
        showAccount: true
        showDark: true
        darkClickListener: button => handleDarkChanged(button)
        closeClickListener: () => {
            dialog_close.open()
        }
        z: 7
    }

    QEvent {
        name: "checkUpdate"
        onTriggered: {
            checkUpdate(false)
        }
    }


    /*
    onLazyLoad: {
        tour.open()
    }
    */
    Component.onCompleted: {
        checkUpdate(true)
    }

    Component.onDestruction: {
        QRouter.exit()
    }

    SystemTrayIcon {
        id: system_tray
        visible: true
        icon.source: "qrc:/qt/qml/src/assets/icons/logo.ico"
        tooltip: "RaportCivic"
        menu: Menu {
            MenuItem {
                text: qsTr("Iesire")
                onTriggered: {
                    QRouter.exit()
                }
            }
        }
        onActivated: reason => {
            if(reason === SystemTrayIcon.Trigger) {
                window.show()
                window.raise()
                window.requestActivate()
            }
        }
    }

    Timer {
        id: timer_window_hide_delay
        interval: 150
        onTriggered: {
            window.hide()
        }
    }

    QContentDialog {
        id: dialog_close
        title: qsTr("Iesire")
        message: qsTr("Esti sigur ca vrei sa parasesti aplicatia?")
        negativeText: qsTr("Minimizare")
        buttonFlags: QContentDialogType.NegativeButton | QContentDialogType.NeutralButton | QContentDialogType.PositiveButton
        onNegativeClicked: {
            system_tray.showMessage(qsTr("Aplicatia a fost ascunsa"), qsTr("Pentru afisare, apsati pe tray pentru a activa din nou fereastra."))
            timer_window_hide_delay.restart()
        }
        positiveText: qsTr("Iesire")
        neutralText: qsTr("Anulare")
        onPositiveClicked: {
            QRouter.exit(0)
        }
    }

    // initialise the stackview-like of qnavigationview
    Item {
        id: page_front
        anchors.fill: parent

        QNavigationView {
            property int clickCount: 0
            id: nav_view /* set the id of push and pop */
            width: parent.width
            height: parent.height
            z: 999
            pageMode: QNavigationViewType.NoStack
            items: ItemsMain
            footerItems: ItemsBase
            topPadding: {
                if(window.useSystemAppBar) {
                    return 0
                }
                return QTools.isMacos() ? 20 : 0
            }
            displayMode: SharedState.displayMode
            logo: "qrc:/qt/qml/src/assets/icons/logo.ico"
            title: "RaportCivic"
            onLogoClicked: {
                clickCount += 1
                showSuccess("%1:%2".arg(qsTr("Click")).arg(clickCount))
                if(clickCount === 5) {
                    clickCount = 0
                }
            }
            autoSuggestBox: QAutoSuggestBox {
                iconSource: FluentIcons.Search
                items: ItemsMain.getSearchData()
                placeholderText: qsTr("Cautare")
                onItemClicked: data => {
                    ItemsMain.startPageByItem(data)
                }
            }
            Component.onCompleted: {
                ItemsMain.navigationView = nav_view
                ItemsBase.navigationView = nav_view
                window.setHitTestVisible(nav_view.buttonMenu)
                window.setHitTestVisible(nav_view.buttonBack)
                window.setHitTestVisible(nav_view.imageLogo)
                setCurrentIndex(0)
            }
        }
    }

    Component {
        id: com_reveal
        CircularReveal {
            id: reveal
            target: window.contentItem
            anchors.fill: parent
            onAnimationFinished: {
                loader_reveal.sourceComponent = undefined
            }
            onImageChanged: {
                changeDark()
            }
        }
    }

    QLoader {
        id: loader_reveal
        anchors.fill: parent
    }

    // raza animatiei circulare
    function distance(x1, y1, x2, y2) {
        return Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
    }

    function handleDarkChanged(button) {
        if(!QTheme.animationEnabled || window.fitsAppBarWindows === false) {
            changeDark()
        } else { // animatia este activata?
            if(loader_reveal.sourceComponent) {
                return
            }
            loader_reveal.sourceComponent = com_reveal
            var target = window.contentItem
            var pos = button.mapToItem(target, 0, 0)
            var mouseX = pos.x
            var mouseY = pos.y
            var radius = Math.max(distance(mouseX, mouseY, 0, 0), distance(mouseX, mouseY, target.width, 0), distance(mouseX, mouseY, 0, target.height), distance(mouseX, mouseY, target.width, target.height))
            var reveal = loader_reveal.item
            reveal.start(reveal.width * Screen.devicePixelRatio, reveal.height * Screen.devicePixelRatio, Qt.point(mouseX, mouseY), radius)
        }
    }

    function changeDark() {
        if(QTheme.dark) {
            QTheme.darkMode = QThemeType.Light
        } else {
            QTheme.darkMode = QThemeType.Dark
        }
    }

    /*
    QTour {
        id: tour
        finishText: qsTr("Finalizare")
        nextText: qsTr("Inainte")
        previousText: qsTr("Inapoi")
        steps: {
            var data = []
            if (!window.useSystemAppBar) {
                data.push({
                    "title": qsTr("Dark Mode"),
                    "description": qsTr("Poti modifica culoarea temei."),
                    "target": () => appBar.buttonDark
                })
            }
            data.push({
                "title": qsTr("Easter Egg"),
                "description": qsTr("Click!!"),
                "target": () => nav_view.imageLogo
            })
            return data
        }
    }
    */

    QContentDialog {
        property string newVerson
        property string body
        id: dialog_update
        title: qsTr("Actualizare")
        message: qsTr("Exista o versiune noua a aplicatiei ") + newVerson + qsTr(" -- Versiune actuala") + AppVersion.version + qsTr(" \nDescarcare versiune noua？\n\nDescriere: \n") + body
        buttonFlags: QContentDialogType.NegativeButton | QContentDialogType.PositiveButton
        negativeText: qsTr("Anulare")
        positiveText: qsTr("Descarcare")
        onPositiveClicked: {
            Qt.openUrlExternally("")
        }
    }

    NetworkCallable {
        id: callable
        property bool silent: true
        onStart: {
            console.debug("Checking for updates...")
        }
        onFinish: {
            console.debug("Updates checked")
            QEventBus.post("checkUpdateFinish")
        }
        onSuccess: result => {
            var data = JSON.parse(result)
            console.debug("Current version " + AppVersion.version)
            console.debug("New version " + data.tag_name)
            if(data.tag_name !== AppVersion.version) {
                dialog_update.newVerson = data.tag_name
                dialog_update.body = data.body
                dialog_update.open()
            } else {
                if(!silent) {
                    showInfo(qsTr("Ultima versiune este deja instalata!"))
                }
            }
        }
        onError: (status, errorString) => {
            if(!silent) {
                showError(qsTr("Eroare intampinata. Conexiune anormala!"))
            }
            console.debug(status + ";" + errorString)
        }
    }

    function checkUpdate(silent) {
        callable.silent = silent
        Network.get("https://api.github.com/repos/armync/RaportCivic/releases/latest").go(callable)
    }
}
