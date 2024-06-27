import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Component
import module

QScrollablePage {
    id: root
    title: qsTr("Date sesizare")

    property bool isUserLoggedIn: AccountManager.isLoggedIn
    property var citizenData: null
    property var address: null

    QInfoBar {
        id: infoBar
        root: root
    }

    DbManager {
        id: dbManager
    }

    function showInfoPos(text, y, x) {
        infoBar.layoutY = y
        infoBar.layoutX = x
        infoBar.showInfo(text)
    }

    Component.onCompleted: {
        if (isUserLoggedIn) {
            var citizenDataResult = dbManager.getCitizenDataByAccountId(AccountManager.accountId)
            if (citizenDataResult.success) {
                citizenData = citizenDataResult.data
            } else {
                console.log("Failed to retrieve citizen data:", citizenDataResult.error)
            }

            var addressDataResult = dbManager.getAddressByAccountId(AccountManager.accountId)
            if (addressDataResult.success) {
                address = addressDataResult.data
            } else {
                console.log("Failed to retrieve address data:", addressDataResult.error)
            }

            if (isUserLoggedIn && !citizenData && !address)
                root.showInfoPos(qsTr("Nu exista date prestabilite in cont"), 25, 275)
        }
    }

    ColumnLayout {
        spacing: 20
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter

        QText {
            text: qsTr("Tip sesizare slectata: ") + ReportBridge.selectedReportId
        }

        QFrame {
            Layout.fillWidth: true
            padding: 20
            Layout.alignment: Qt.AlignHCenter

            ColumnLayout {
                spacing: 10
                Layout.alignment: Qt.AlignHCenter

                RowLayout {
                    spacing: 10
                    Layout.alignment: Qt.AlignHCenter

                    QToggleSwitch {
                        id: useExistingDataToggle
                        text: isUserLoggedIn ? qsTr("Utilizeaza datele presetate") : qsTr("Introdu informatiile necesare")
                        visible: isUserLoggedIn && citizenData && address
                        checked: visible
                    }

                    QButton {
                        text: qsTr("Inapoi")
                        onClicked: nav_view.push("qrc:/qt/qml/src/qml/screen/ReportSelection.qml")
                    }

                    QButton {
                        text: qsTr("Inainte")
                        onClicked: {
                            if (isUserLoggedIn && useExistingDataToggle.checked && citizenData && address) {
                                // existing data
                                ReportBridge.firstName = citizenData.first_name
                                ReportBridge.lastName = citizenData.last_name
                                ReportBridge.personalNumericCode = citizenData.personal_numeric_code
                                ReportBridge.contactEmail = citizenData.contact_email
                                ReportBridge.phone = citizenData.phone

                                ReportBridge.county = address.county
                                ReportBridge.city = address.city
                                ReportBridge.street = address.street
                                ReportBridge.building = address.building
                                ReportBridge.entrance = address.entrance
                                ReportBridge.apartment = address.apartment
                            }

                            // check if data set in reportbridge, be it manually or preexisting data
                            if (ReportBridge.firstName !== "" && ReportBridge.lastName !== "" && ReportBridge.personalNumericCode !== "" &&
                                    ReportBridge.contactEmail !== "" && ReportBridge.county !== "" && ReportBridge.city !== "" && ReportBridge.street !== "") {
                                nav_view.push("qrc:/qt/qml/src/qml/screen/ReportDetails.qml")
                            } else {
                                console.log("Incomplete data in ReportBridge.")
                            }
                        }
                    }
                }
            }
        }

        QFrame {
            Layout.fillWidth: true
            padding: 20
            Layout.alignment: Qt.AlignHCenter

            ColumnLayout {
                spacing: 20

                ColumnLayout {
                    id: reportInput
                    visible: !isUserLoggedIn || !useExistingDataToggle.checked || !citizenData || !address
                    Layout.fillWidth: true

                    ReportInput {
                        Layout.alignment: Qt.AlignLeft
                        Layout.preferredHeight: root.height * 0.7
                    }
                }

                GridLayout {
                    visible: isUserLoggedIn && useExistingDataToggle.checked && citizenData && address
                    columns: 2
                    columnSpacing: 10
                    rowSpacing: 5

                    // personal information
                    QText {
                        text: qsTr("Prenume:")
                    }
                    QText {
                        text: citizenData ? citizenData.first_name : ""
                    }

                    QText {
                        text: qsTr("Nume de familie:")
                    }
                    QText {
                        text: citizenData ? citizenData.last_name : ""
                    }

                    QText {
                        text: qsTr("CNP:")
                    }
                    QText {
                        text: citizenData ? citizenData.personal_numeric_code : ""
                    }

                    QText {
                        text: qsTr("Nume utilizator:")
                    }
                    QText {
                        text: citizenData && citizenData.username ? citizenData.username : "<font color='red'><b>" + qsTr("(necompletat)") + "</b></font>"
                        textFormat: Text.RichText
                    }

                    QText {
                        text: qsTr("Email contact:")
                    }
                    QText {
                        text: citizenData ? citizenData.contact_email : ""
                    }

                    QText {
                        text: qsTr("Numar de telefon:")
                    }
                    QText {
                        text: citizenData && citizenData.phone ? citizenData.phone : "<font color='red'><b>" + qsTr("(necompletat)") + "</b></font>"
                        textFormat: Text.RichText
                    }

                    // address
                    QText {
                        text: qsTr("Judet:")
                    }
                    QText {
                        text: address ? address.county : ""
                    }

                    QText {
                        text: qsTr("Oras:")
                    }
                    QText {
                        text: address ? address.city : ""
                    }

                    QText {
                        text: qsTr("Strada:")
                    }
                    QText {
                        text: address ? address.street : ""
                    }

                    QText {
                        text: qsTr("Bloc:")
                    }
                    QText {
                        text: address && address.building ? address.building : "<font color='red'><b>" + qsTr("(necompletat)") + "</b></font>"
                        textFormat: Text.RichText
                    }

                    QText {
                        text: qsTr("Scara:")
                    }
                    QText {
                        text: address && address.entrance ? address.entrance : "<font color='red'><b>" + qsTr("(necompletat)") + "</b></font>"
                        textFormat: Text.RichText
                    }

                    QText {
                        text: qsTr("Apartament:")
                    }
                    QText {
                        text: address && address.apartment ? address.apartment : "<font color='red'><b>" + qsTr("(necompletat)") + "</b></font>"
                        textFormat: Text.RichText
                    }
                }
            }
        }
    }
}
