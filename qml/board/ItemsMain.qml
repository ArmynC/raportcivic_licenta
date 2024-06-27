pragma Singleton

import QtQuick
import QtQuick.Layouts
import Component
import module

QObject {

    property var navigationView

    property bool isLoggedIn: AccountManager.isLoggedIn

    function rename(item, newName) {
        if (newName && newName.trim().length > 0) {
            item.title = newName
        }
    }

    QPaneItem {
        id: item_home
        title: qsTr("Acasa")
        icon: FluentIcons.Home
        url: "qrc:/qt/qml/src/qml/screen/Home.qml"
        function homeNav() {
            navigationView.push(url)
        }
        onTap: homeNav()
    }

    /*
    QPaneItemSeparator {
        spacing: 10
        size: 1
    }


    QPaneItem {
        id: item_account
        title: qsTr("Cont")
        icon: FluentIcons.Home
        url: "qrc:/qt/qml/src/qml/pane/AccountContent.qml"
        onTap: navigationView.push(url)
    }
    */


    QPaneItemSeparator {
        spacing: 10
        size: 1
    }

    QPaneItemExpander {
        title: qsTr("Generare sesizari")
        icon: FluentIcons.Edit

        QPaneItem {
            id: item_reportType
            title: qsTr("Sablon")
            shortcut: ({
                "image": "/qt/qml/src/assets/img/btn/RichEditBox.png",
                "order": 1,
                "desc": qsTr("Ceva in neregula? Foloseste sesizarile puse la dispozitie.")
            })
            url: "qrc:/qt/qml/src/qml/screen/ReportSelection.qml"
            onTap: navigationView.push(url)
        }
    }

    QPaneItemSeparator {
        visible: isLoggedIn
        spacing: 10
        size: 1
    }

    QPaneItemExpander {
        title: qsTr("Ghid")
        icon: FluentIcons.KnowledgeArticle

        QPaneItem {
            id: item_civicalGuide
            title: qsTr("Concepte civice")
            shortcut: ({
                "image": "/qt/qml/src/assets/img/btn/FilePicker.png",
                "order": 1,
                "user": false,
                "desc": qsTr("Afla pe scurt informatiile dorite. Poti fundamenta cateva dintre concepte.")
            })
            url: "qrc:/qt/qml/src/qml/screen/CivicalGuide.qml"
            function civicalGuideNav() {
                navigationView.push(url)
            }
            onTap: civicalGuideNav()
        }

        QPaneItem {
            id: item_544Guide
            title: qsTr("Legea 544 pe scurt")
            url: "qrc:/qt/qml/src/qml/screen/544Guide.qml"
            function guide544Nav() {
                navigationView.push(url)
            }
            onTap: guide544Nav()
        }

        QPaneItem {
            id: item_caseGuide
            title: qsTr("Orientare cazuri")
            url: "qrc:/qt/qml/src/qml/screen/CaseGuide.qml"
            function caseGuideNav() {
                navigationView.push(url)
            }
            onTap: caseGuideNav()
        }
    }

    QPaneItemSeparator {
        visible: isLoggedIn
        spacing: 10
        size: 1
    }

    QPaneItemExpander {
        visible: isLoggedIn
        title: qsTr("Utilizator")
        icon: FluentIcons.PhoneBook

        QPaneItem {
            id: item_profileDetails
            title: qsTr("Profil")
            shortcut: ({
                "image": "/qt/qml/src/assets/img/btn/PersonPicture.png",
                "order": 1,
                "user": true,
                "desc": qsTr("Modifica profilul. Iti va fi de folos in conturarea sabloanelor.")
            })
            url: "qrc:/qt/qml/src/qml/screen/UserManagement.qml"
            function profileNav() {
                navigationView.push(url)
            }
            onTap: profileNav()
        }
    }

    QPaneItemSeparator {
        visible: isLoggedIn
        spacing: 10
        size: 1
    }

    /*
    QPaneItemExpander {
        title: qsTr("Misc")
        icon: FluentIcons.Shop

        QPaneItem {
            title: qsTr("Test Crash")
            onTapListener: function () {
                AppVersion.testCrash()
            }
            Component.onCompleted: {
                visible = QTools.isWin()
            }
        }
    }
    */

    function getSearchData() {
        if(!navigationView) {
            return
        }
        var arr = []
        var items = navigationView.getItems()
        for(var i = 0; i < items.length; i++) {
            var item = items[i]
            if(item instanceof QPaneItem) {
                if(item.parent instanceof QPaneItemExpander) {
                    arr.push({
                        "title": `${item.parent.title} -> ${item.title}`,
                        "key": item.key
                    })
                } else
                    arr.push({
                        "title": item.title,
                        "key": item.key
                    })
            }
        }
        return arr
    }

    function startPageByItem(data) {
        navigationView.startPageByItem(data)
    }

    function getShortcuts() {
        var arr = []
        var items = navigationView.getItems()
        for (var i = 0; i < items.length; i++) {
            var item = items[i]
            if (item instanceof QPaneItem && item.shortcut && !item.shortcut.user) { // if element defined as shortcut
                arr.push(item)
            }
        }
        arr.sort(function (o1, o2) {
            return o2.shortcut.order - o1.shortcut.order
        })
        return arr
    }

    function getShortcutsUser() {
        var arr = []
        var items = navigationView.getItems()
        for (var i = 0; i < items.length; i++) {
            var item = items[i]
            if (item instanceof QPaneItem && item.shortcut && item.shortcut.user) { // if element defined as shortcut & isUser
                arr.push(item)
            }
        }
        arr.sort(function (o1, o2) {
            return o2.shortcut.order - o1.shortcut.order
        })
        return arr
    }

    Connections {
        target: AccountManager
        function onLoggedInChanged() {
            isLoggedIn = AccountManager.isLoggedIn
        }
    }

    // access navigation handler with signals
    Connections {
        target: QmlBridge
        function onLogoutSignal() {
            // console.log("Going home...")
            item_home.homeNav()
        }
        function onLoginSignal() {
            // console.log("Going home...")
            item_home.homeNav()
        }
        function onAccountSettingsSignal() {
            // console.log("Going to settings...")
            item_profileDetails.profileNav()
        }
    }
}
