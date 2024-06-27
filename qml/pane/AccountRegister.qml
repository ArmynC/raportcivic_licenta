import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Component
import module

ColumnLayout {
    anchors.fill: parent
    spacing: 20

    RowLayout {
        Layout.alignment: Qt.AlignHCenter
        Layout.topMargin: 20

        Image {
            source: QTheme.dark ? "qrc:/qt/qml/src/assets/icons/logo_light_word.png" : "qrc:/qt/qml/src/assets/icons/logo_dark_word.png"
            Layout.preferredWidth: 200
            Layout.preferredHeight: 30
            fillMode: Image.PreserveAspectFit
            mipmap: true
        }
    }

    Rectangle {
        Layout.alignment: Qt.AlignHCenter
        Layout.bottomMargin: 20
        height: 1
        width: 50
        color: QTheme.dark ? Qt.rgba(1, 1, 1, 0.3) : Qt.rgba(0, 0, 0, 0.3)
    }

    ColumnLayout {
        Layout.alignment: Qt.AlignHCenter
        spacing: 15

        // declarative qml component (c++ module)

        PasswordValidator {
            id: passwordValidator
        }

        PasswordHasher {
            id: passwordHasher
        }

        DbManager {
            id: dbManager
        }

        QTextBox {
            id: textbox_email
            placeholderText: qsTr("Email")
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 260
        }

        QTextBox {
            id: textbox_password
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 260
            placeholderText: qsTr("Parola")
            echoMode: TextInput.Password
        }

        QTextBox {
            id: textbox_confirmPassword
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 260
            placeholderText: qsTr("Confirma Parola")
            echoMode: TextInput.Password
        }

        QFilledButton {
            text: qsTr("Inregistrare")
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 20
            onClicked: {
                if (textbox_email.text === "") {
                    window.showErrorPos(qsTr("Introdu un email"), 108)
                    return
                }

                if (!passwordValidator.isEmailValid(textbox_email.text)) {
                    window.showErrorPos(passwordValidator.getErrorMessage(), 108)
                    return
                }

                if (textbox_password.text === "") {
                    window.showErrorPos(qsTr("Introdu o parola"), 108)
                    return
                }

                if (textbox_confirmPassword.text === "") {
                    window.showErrorPos(qsTr("Confirma parola"), 108)
                    return
                }

                if (textbox_password.text !== textbox_confirmPassword.text) {
                    window.showErrorPos(qsTr("Parolele nu corespund"), 108)
                    return
                }

                if (!passwordValidator.isPasswordStrong(textbox_password.text)) {
                    window.showErrorPos(passwordValidator.getErrorMessage(), 108)
                    return
                }

                var hashedPassword = passwordHasher.hashPassword(textbox_password.text)

                if (dbManager.addUser(textbox_email.text, hashedPassword)) {
                    window.showSuccessPos(qsTr("Inregistrare cu succes"), 135)
                    window.loadLoginAccount() // back to login page
                } else {
                    window.showErrorPos(qsTr("Eroare la inregistrare"), 108)
                }
            }
        }
    }

    RowLayout {
        Layout.leftMargin: 40
        Layout.rightMargin: 40
        Layout.bottomMargin: 40

        QIconButton {
            iconSource: FluentIcons.ChevronLeft
            iconSize: 15
            text: qsTr("Inapoi")
            Layout.alignment: Qt.AlignLeft
            display: Button.TextBesideIcon
            onClicked: {
                window.loadLoginAccount()
            }
        }
    }
}
