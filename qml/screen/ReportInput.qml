import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Component
import module

Item {
    id: root

    property var personalData: ({})
    property var addressData: ({})

    ProfileValidator {
        id: profileValidator
    }

    DbManager {
        id: dbManager
    }

    QInfoBar {
        id: infoBar
        root: root
    }

    function showSuccessPos(text, y, x) {
        infoBar.layoutY = y
        infoBar.layoutX = x
        infoBar.showSuccess(text)
    }

    ColumnLayout {
        spacing: 30

        RowLayout {
            spacing: 30

            ColumnLayout {
                spacing: 50 // grid and QButton spacing

                ColumnLayout {
                    spacing: 30

                    QText {
                        text: qsTr("Informatii personale")
                        font: QTextStyle.BodyStrong
                    }

                    GridLayout {
                        columns: 2
                        columnSpacing: 15
                        rowSpacing: 25

                        ColumnLayout {
                            spacing: 10

                            QText {
                                text: qsTr("Prenume")
                                font: QTextStyle.Subtitle
                                Layout.preferredWidth: 140
                            }

                            QTextBox {
                                id: firstNameField
                                placeholderText: qsTr("Prenume")
                                Layout.preferredWidth: 140
                            }
                        }

                        ColumnLayout {
                            spacing: 10

                            QText {
                                text: qsTr("Nume de familie")
                                font: QTextStyle.Subtitle
                            }

                            QTextBox {
                                id: lastNameField
                                placeholderText: qsTr("Nume de familie")
                                Layout.preferredWidth: 140
                            }
                        }

                        ColumnLayout {
                            spacing: 10

                            QText {
                                text: qsTr("CNP")
                                font: QTextStyle.Subtitle
                            }

                            QTextBox {
                                id: personalNumericCodeField
                                placeholderText: qsTr("CNP")
                                Layout.preferredWidth: 140
                            }
                        }

                        ColumnLayout {
                            spacing: 10

                            QText {
                                text: qsTr("Email contact")
                                font: QTextStyle.Subtitle
                            }

                            QTextBox {
                                id: contactEmailField
                                placeholderText: qsTr("Email Contact")
                                Layout.preferredWidth: 140
                            }
                        }

                        ColumnLayout {
                            spacing: 10

                            QText {
                                text: qsTr("Numar de telefon")
                                font: QTextStyle.Subtitle
                            }

                            QTextBox {
                                id: phoneField
                                placeholderText: qsTr("Numar de telefon")
                                Layout.preferredWidth: 140
                            }
                        }
                    }

                    QButton {
                        text: qsTr("Salveaza identificatorii")
                        onClicked: {
                            var validationErrors = []

                            var firstNameError = profileValidator.validateName(firstNameField.text, true)
                            if (firstNameError !== "") {
                                validationErrors.push(firstNameError)
                                firstNameField.errorMessage = firstNameError
                            } else {
                                firstNameField.errorMessage = ""
                            }

                            var lastNameError = profileValidator.validateName(lastNameField.text, false)
                            if (lastNameError !== "") {
                                validationErrors.push(lastNameError)
                                lastNameField.errorMessage = lastNameError
                            } else {
                                lastNameField.errorMessage = ""
                            }

                            var cnpError = profileValidator.validateCNP(personalNumericCodeField.text)
                            if (cnpError !== "") {
                                validationErrors.push(cnpError)
                                personalNumericCodeField.errorMessage = cnpError
                            } else {
                                personalNumericCodeField.errorMessage = ""
                            }

                            var emailError = profileValidator.validateEmail(contactEmailField.text)
                            if (emailError !== "") {
                                validationErrors.push(emailError)
                                contactEmailField.errorMessage = emailError
                            } else {
                                contactEmailField.errorMessage = ""
                            }

                            var phoneError = profileValidator.validatePhoneNumber(phoneField.text)
                            if (phoneError !== "") {
                                validationErrors.push(phoneError)
                                phoneField.errorMessage = phoneError
                            } else {
                                phoneField.errorMessage = ""
                            }

                            if (validationErrors.length === 0) {
                                ReportBridge.firstName = firstNameField.text
                                ReportBridge.lastName = lastNameField.text
                                ReportBridge.personalNumericCode = personalNumericCodeField.text
                                ReportBridge.contactEmail = contactEmailField.text
                                ReportBridge.phone = phoneField.text

                                root.showSuccessPos(qsTr("Informatii personale incarcate"), 25, 600)
                            } else {
                                console.log("Personal data validation error.")
                            }
                        }
                    }
                }
            }

            ColumnLayout {
                spacing: 50 // grid and QButton spacing

                ColumnLayout {
                    spacing: 30

                    QText {
                        text: qsTr("Adresa")
                        font: QTextStyle.BodyStrong
                    }

                    GridLayout {
                        columns: 2
                        columnSpacing: 15
                        rowSpacing: 25

                        ColumnLayout {
                            spacing: 10

                            QText {
                                text: qsTr("Judet")
                                font: QTextStyle.Subtitle
                                Layout.preferredWidth: 140
                            }

                            QComboBox {
                                id: countyField
                                editable: true
                                model: JsonParser.getAllCounties()
                                onAccepted: {
                                    if (find(editText) === -1)
                                        model.append({
                                            "text": editText
                                    })
                                }
                                onCurrentTextChanged: {
                                    cityField.model = JsonParser.getCitiesByCounty(currentText)
                                }
                            }
                        }

                        ColumnLayout {
                            spacing: 10

                            QText {
                                text: qsTr("Oras")
                                font: QTextStyle.Subtitle
                                Layout.preferredWidth: 140
                            }

                            QComboBox {
                                id: cityField
                                editable: true
                                model: JsonParser.getCitiesByCounty(countyField.currentText)
                                onAccepted: {
                                    if (find(editText) === -1)
                                        model.append({
                                            "text": editText
                                    })
                                }
                            }
                        }

                        ColumnLayout {
                            spacing: 10

                            QText {
                                text: qsTr("Strada")
                                font: QTextStyle.Subtitle
                            }

                            QTextBox {
                                id: streetField
                                placeholderText: qsTr("Strada")
                                Layout.preferredWidth: 140
                            }
                        }

                        ColumnLayout {
                            spacing: 10

                            QText {
                                text: qsTr("Bloc")
                                font: QTextStyle.Subtitle
                            }

                            QTextBox {
                                id: buildingField
                                placeholderText: qsTr("Bloc")
                                Layout.preferredWidth: 140
                            }
                        }

                        ColumnLayout {
                            spacing: 10

                            QText {
                                text: qsTr("Scara")
                                font: QTextStyle.Subtitle
                            }
                            QTextBox {
                                id: entranceField
                                placeholderText: qsTr("Scara")
                                Layout.preferredWidth: 140
                            }
                        }

                        ColumnLayout {
                            spacing: 10

                            QText {
                                text: qsTr("Apartament")
                                font: QTextStyle.Subtitle
                            }

                            QTextBox {
                                id: apartmentField
                                placeholderText: qsTr("Apartament")
                                Layout.preferredWidth: 140
                            }
                        }
                    }

                    QButton {
                        text: qsTr("Salveaza adresa")
                        onClicked: {
                            var validationErrors = []

                            var streetEmptyError = profileValidator.validateNotEmpty(streetField.text)
                            if (streetEmptyError !== "") {
                                validationErrors.push(streetEmptyError)
                                streetField.errorMessage = streetEmptyError
                            } else {
                                streetField.errorMessage = ""
                            }

                            if (validationErrors.length === 0) {
                                ReportBridge.county = countyField.currentText
                                ReportBridge.city = cityField.currentText
                                ReportBridge.street = streetField.text
                                ReportBridge.building = buildingField.text
                                ReportBridge.entrance = entranceField.text
                                ReportBridge.apartment = apartmentField.text

                                root.showSuccessPos(qsTr("Informatiile adresei au fost incarcate"), 25, 600)

                            } else {
                                console.log("Address data validation errors.")
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 20
            height: 1
            width: 200
            color: QTheme.dark ? Qt.rgba(1, 1, 1, 0.3) : Qt.rgba(0, 0, 0, 0.3)
        }

        ColumnLayout {
            scale: 1.2
            transformOrigin: Item.TopLeft
            QText {
                text: qsTr("Inainte de completarea sablonului sesizarii este nevoie de cateva date. \nAcestea sunt necesare pentru legitimitatea petitiei.")
                font: QTextStyle.BodyStrong
                Layout.alignment: Qt.AlignLeft
            }
        }
    }
}
