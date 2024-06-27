import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Component
import module

QScrollablePage {
    id: root
    title: qsTr("Profil utilizator")

    property int accountId: -1
    property var citizenData: null
    property var address: null
    property bool editPersonalInfoMode: false
    property bool editAddressMode: false

    ProfileValidator {
        id: profileValidator
    }

    DbManager {
        id: dbManager
    }

    Component.onCompleted: {
        console.log("UserManagement::Component.onCompleted")
        if (AccountManager.isLoggedIn && AccountManager.accountId !== undefined) {
            console.log("AccountManager.accountId:", AccountManager.accountId)
            accountId = AccountManager.accountId

            // retrieve citizen data from the database
            var citizenDataResult = dbManager.getCitizenDataByAccountId(accountId)
            if (citizenDataResult.success) {
                citizenData = citizenDataResult.data
            } else {
                console.log("Failed to retrieve citizen data:", citizenDataResult.error)
                citizenData = null
            }

            // retrieve address data from the database
            var addressDataResult = dbManager.getAddressByAccountId(accountId)
            if (addressDataResult.success) {
                address = addressDataResult.data
            } else {
                console.log("Failed to retrieve address data:", addressDataResult.error)
                address = null
            }
        }

        // console.log("Citizen Data: ", JSON.stringify(citizenData));
        // console.log("Address Data: ", JSON.stringify(address));
    }

    function savePersonalInfo() {
        var personalInfoValidationErrors = []

        // personal informations - custom validation
        var firstNameError = profileValidator.validateName(firstNameField.text, true)
        if (firstNameError !== "") {
            personalInfoValidationErrors.push(firstNameError)
            firstNameField.errorMessage = firstNameError
        } else {
            firstNameField.errorMessage = ""
        }

        var lastNameError = profileValidator.validateName(lastNameField.text, false)
        if (lastNameError !== "") {
            personalInfoValidationErrors.push(lastNameError)
            lastNameField.errorMessage = lastNameError
        } else {
            lastNameField.errorMessage = ""
        }

        var cnpError = profileValidator.validateCNP(personalNumericCodeField.text)
        if (cnpError !== "") {
            personalInfoValidationErrors.push(cnpError)
            personalNumericCodeField.errorMessage = cnpError
        } else {
            personalNumericCodeField.errorMessage = ""
        }

        var emailError = profileValidator.validateEmail(contactEmailField.text)
        if (emailError !== "") {
            personalInfoValidationErrors.push(emailError)
            contactEmailField.errorMessage = emailError
        } else {
            contactEmailField.errorMessage = ""
        }

        var phoneError = profileValidator.validatePhoneNumber(phoneField.text)
        if (phoneError !== "") {
            personalInfoValidationErrors.push(phoneError)
            phoneField.errorMessage = phoneError
        } else {
            phoneField.errorMessage = ""
        }

        if (personalInfoValidationErrors.length === 0) {
            if (citizenData === null) {
                // create new citizen data
                var createResult = dbManager.createCitizenData(accountId, lastNameField.text, firstNameField.text, personalNumericCodeField.text, usernameField.text, contactEmailField.text, phoneField.text)

                if (createResult.success) {
                    console.log("Citizen data created successfully.")
                    // citizenData = createResult.data
                } else {
                    console.log("Failed to create citizen data:", createResult.error)
                }
            } else {
                // update existing citizen data
                var updateResult = dbManager.updateCitizenData(citizenData.citizen_id, lastNameField.text, firstNameField.text, personalNumericCodeField.text, usernameField.text, contactEmailField.text, phoneField.text)

                if (updateResult.success) {
                    console.log("Citizen data updated successfully.")
                    // citizenData = updateResult.data
                } else {
                    console.log("Failed to update citizen data:", updateResult.error)
                }
            }
        }
    }

    function saveAddress() {

        var addressValidationErrors = []

        // address - generic empty fields
        var streetEmptyError = profileValidator.validateNotEmpty(streetField.text)
        if (streetEmptyError !== "") {
            addressValidationErrors.push(streetEmptyError)
            streetField.errorMessage = streetEmptyError
        } else {
            streetField.errorMessage = ""
        }

        if (addressValidationErrors.length === 0) {
            if (address === null) {
                // create new address
                var createResult = dbManager.createAddress(citizenData.citizen_id, countyField.currentText, cityField.currentText, streetField.text, buildingField.text, entranceField.text, apartmentField.text)

                if (createResult.success) {
                    console.log("Address created successfully.")
                    // address = createResult.data
                } else {
                    console.log("Failed to create address:", createResult.error)
                }
            } else {
                // update existing address
                var updateResult = dbManager.updateAddress(address.address_id, countyField.currentText, cityField.currentText, streetField.text, buildingField.text, entranceField.text, apartmentField.text)

                if (updateResult.success) {
                    console.log("Address updated successfully.")
                    // address = updateResult.data
                } else {
                    console.log("Failed to update address:", updateResult.error)
                }
            }
        }
    }

    // auto refresh the data string when exiting edit mode
    function refreshData() {
        // retrieve citizen data from db
        var citizenDataResult = dbManager.getCitizenDataByAccountId(accountId)
        if (citizenDataResult.success) {
            citizenData = citizenDataResult.data
        } else {
            console.log("Failed to retrieve citizen data:", citizenDataResult.error)
            citizenData = null
        }

        // retrieve address data from db
        var addressDataResult = dbManager.getAddressByAccountId(accountId)
        if (addressDataResult.success) {
            address = addressDataResult.data
        } else {
            console.log("Failed to retrieve address data:", addressDataResult.error)
            address = null
        }
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: 15

        QFrame {
            Layout.fillWidth: true
            padding: 20

            ColumnLayout {
                spacing: 20

                QText {
                    text: qsTr("Informatii personale")
                    font: QTextStyle.BodyStrong
                }

                GridLayout {
                    columns: 2
                    columnSpacing: 70
                    rowSpacing: 25
                    Layout.fillWidth: true

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        QText {
                            text: qsTr("Prenume")
                            font: QTextStyle.Subtitle
                        }

                        Item {
                            width: 180
                            height: 40
                            QText {
                                id: firstNameText
                                text: citizenData && citizenData.first_name ? citizenData.first_name : qsTr("Nu exista date")
                                visible: !editPersonalInfoMode
                            }
                            QTextBox {
                                id: firstNameField
                                placeholderText: qsTr("Prenume")
                                text: citizenData && citizenData.first_name ? citizenData.first_name : ""
                                visible: editPersonalInfoMode
                            }
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        QText {
                            text: qsTr("Nume de familie")
                            font: QTextStyle.Subtitle
                        }

                        Item {
                            width: 180
                            height: 40
                            QText {
                                id: lastNameText
                                text: citizenData && citizenData.last_name ? citizenData.last_name : qsTr("Nu exista date")
                                visible: !editPersonalInfoMode
                            }
                            QTextBox {
                                id: lastNameField
                                placeholderText: qsTr("Nume de familie")
                                text: citizenData && citizenData.last_name ? citizenData.last_name : ""
                                visible: editPersonalInfoMode
                            }
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        QText {
                            text: qsTr("CNP")
                            font: QTextStyle.Subtitle
                        }

                        Item {
                            width: 180
                            height: 40
                            QText {
                                id: personalNumericCodeText
                                text: citizenData && citizenData.personal_numeric_code ? citizenData.personal_numeric_code : qsTr("Nu exista date")
                                visible: !editPersonalInfoMode
                            }
                            QTextBox {
                                id: personalNumericCodeField
                                placeholderText: qsTr("CNP")
                                text: citizenData && citizenData.personal_numeric_code ? citizenData.personal_numeric_code : ""
                                visible: editPersonalInfoMode
                            }
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        QText {
                            text: qsTr("Nume utilizator")
                            font: QTextStyle.Subtitle
                        }

                        Item {
                            width: 180
                            height: 40
                            QText {
                                id: usernameText
                                text: citizenData && citizenData.username ? citizenData.username : qsTr("Nu exista date")
                                visible: !editPersonalInfoMode
                            }
                            QTextBox {
                                id: usernameField
                                placeholderText: qsTr("Nume utilizator")
                                text: citizenData && citizenData.username ? citizenData.username : ""
                                visible: editPersonalInfoMode
                            }
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        QText {
                            text: qsTr("Email contact")
                            font: QTextStyle.Subtitle
                        }

                        Item {
                            width: 180
                            height: 40
                            QText {
                                id: contactEmailText
                                text: citizenData && citizenData.contact_email ? citizenData.contact_email : qsTr("Nu exista date")
                                visible: !editPersonalInfoMode
                            }
                            QTextBox {
                                id: contactEmailField
                                placeholderText: qsTr("Email contact")
                                text: citizenData && citizenData.contact_email ? citizenData.contact_email : ""
                                visible: editPersonalInfoMode
                            }
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        QText {
                            text: qsTr("Numar de telefon")
                            font: QTextStyle.Subtitle
                        }

                        Item {
                            width: 180
                            height: 40
                            QText {
                                id: phoneText
                                text: citizenData && citizenData.phone ? citizenData.phone : qsTr("Nu exista date")
                                visible: !editPersonalInfoMode
                            }
                            QTextBox {
                                id: phoneField
                                placeholderText: qsTr("Numar de telefon")
                                text: citizenData && citizenData.phone ? citizenData.phone : ""
                                visible: editPersonalInfoMode
                            }
                        }
                    }
                }

                RowLayout {
                    Layout.alignment: Qt.AlignLeft
                    spacing: 10

                    QToggleButton {
                        id: editPersonalInfoButton
                        text: editPersonalInfoMode ? qsTr("Mod vizualizare") : qsTr("Modifica date")
                        onClicked: {
                            editPersonalInfoMode = !editPersonalInfoMode
                            if (!editPersonalInfoMode) {
                                refreshData()
                            }
                        }
                    }

                    QButton {
                        text: qsTr("Salveaza")
                        visible: editPersonalInfoMode
                        onClicked: savePersonalInfo()
                    }
                }
            }
        }

        QFrame {
            Layout.fillWidth: true
            padding: 20

            ColumnLayout {
                spacing: 20

                QText {
                    text: qsTr("Adresa")
                    font: QTextStyle.BodyStrong
                }

                GridLayout {
                    columns: 2
                    columnSpacing: 70
                    rowSpacing: 20
                    Layout.fillWidth: true

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        QText {
                            text: qsTr("Judet")
                            font: QTextStyle.Subtitle
                        }

                        Item {
                            width: 180
                            height: 40
                            QText {
                                id: countyText
                                text: address && address.county ? address.county : qsTr("Nu exista date")
                                visible: !editAddressMode
                            }
                            QComboBox {
                                id: countyField
                                editable: true // data seeker
                                visible: editAddressMode
                                model: JsonParser.getAllCounties()
                                onAccepted: { // select data if not present
                                    if (find(editText) === -1)
                                        model.append({text: editText})
                                }
                                onCurrentTextChanged: {
                                    cityField.model = JsonParser.getCitiesByCounty(currentText)
                                }
                            }
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        QText {
                            text: qsTr("Oras")
                            font: QTextStyle.Subtitle
                        }

                        Item {
                            width: 180
                            height: 40
                            QText {
                                id: cityText
                                text: address && address.city ? address.city : qsTr("Nu exista date")
                                visible: !editAddressMode
                            }
                            QComboBox {
                                id: cityField
                                editable: true // data seeker
                                visible: editAddressMode
                                model: JsonParser.getCitiesByCounty(countyField.currentText)
                                onAccepted: { // select data if not present
                                    if (find(editText) === -1)
                                        model.append({text: editText})
                                }
                            }
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        QText {
                            text: qsTr("Strada")
                            font: QTextStyle.Subtitle
                        }

                        Item {
                            width: 180
                            height: 40
                            QText {
                                id: streetText
                                text: address && address.street ? address.street : qsTr("Nu exista date")
                                visible: !editAddressMode
                            }
                            QTextBox {
                                id: streetField
                                placeholderText: qsTr("Strada")
                                text: address && address.street ? address.street : ""
                                visible: editAddressMode
                            }
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        QText {
                            text: qsTr("Bloc")
                            font: QTextStyle.Subtitle
                        }

                        Item {
                            width: 180
                            height: 40
                            QText {
                                id: buildingText
                                text: address && address.building ? address.building : qsTr("Nu exista date")
                                visible: !editAddressMode
                            }
                            QTextBox {
                                id: buildingField
                                placeholderText: qsTr("Bloc")
                                text: address && address.building ? address.building : ""
                                visible: editAddressMode
                            }
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        QText {
                            text: qsTr("Scara")
                            font: QTextStyle.Subtitle
                        }

                        Item {
                            width: 180
                            height: 40
                            QText {
                                id: entranceText
                                text: address && address.entrance ? address.entrance : qsTr("Nu exista date")
                                visible: !editAddressMode
                            }
                            QTextBox {
                                id: entranceField
                                placeholderText: qsTr("Scara")
                                text: address && address.entrance ? address.entrance : ""
                                visible: editAddressMode
                            }
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        QText {
                            text: qsTr("Apartament")
                            font: QTextStyle.Subtitle
                        }

                        Item {
                            width: 180
                            height: 40
                            QText {
                                id: apartmentText
                                text: address && address.apartment ? address.apartment : qsTr("Nu exista date")
                                visible: !editAddressMode
                            }
                            QTextBox {
                                id: apartmentField
                                placeholderText: qsTr("Apartament")
                                text: address && address.apartment ? address.apartment : ""
                                visible: editAddressMode
                            }
                        }
                    }
                }

                RowLayout {
                    Layout.alignment: Qt.AlignLeft
                    spacing: 10

                    QToggleButton {
                        id: editAddressButton
                        text: editAddressMode ? qsTr("Mod vizualizare") : qsTr("Modifica date")
                        onClicked: {
                            editAddressMode = !editAddressMode
                            if (!editAddressMode) {
                                refreshData()
                            }
                        }
                    }

                    QButton {
                        text: qsTr("Salveaza")
                        visible: editAddressMode
                        onClicked: saveAddress()
                    }
                }
            }
        }
    }
}
