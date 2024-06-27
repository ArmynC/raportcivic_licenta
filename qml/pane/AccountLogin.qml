import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Component
import module

ColumnLayout {
    id: loginPage
    anchors.fill: parent
    spacing: 20

    property bool closing: false

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
        Layout.topMargin: 20
        height: 1
        width: 50
        color: QTheme.dark ? Qt.rgba(1, 1, 1, 0.3) : Qt.rgba(0, 0, 0, 0.3)
    }

    ColumnLayout {
        Layout.alignment: Qt.AlignHCenter
        Layout.topMargin: 40
        spacing: 15

        // declarative qml component (c++ module)
        PasswordValidator {
            id: passwordValidator
        }

        DbManager {
            id: dbManager
        }

        PasswordHasher {
            id: passwordHasher
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

        QFilledButton {
            text: qsTr("Autentificare")
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 20
            onClicked: {
                if (textbox_email.text === "") {
                    window.showErrorPos(qsTr("Introdu un email"), 135)
                    return
                }
                if (textbox_password.text === "") {
                    window.showErrorPos(qsTr("Introdu o parola"), 135)
                    return
                }

                if (AccountManager.loginAccount(textbox_email.text, textbox_password.text)) {
                    window.showSuccessPos(qsTr("Autentificare cu succes"), 135)
                    console.log("Login successful")
                    QmlBridge.login()
                    delayTimer.start(); // proceed to fade-out and close window if signed-in
                } else {
                    window.showErrorPos(qsTr("Email sau parola incorecta"), 135)
                }
            }
        }
    }

    RowLayout {
        spacing: 20
        Layout.leftMargin: 40
        Layout.rightMargin: 40
        Layout.bottomMargin: 40

        QTextButton {
            text: qsTr("Creare cont")
            Layout.alignment: Qt.AlignLeft
            onClicked: {
                window.loadRegisterAccount()
            }
        }

        Item {
            Layout.fillWidth: true
        }

        /*
        QTextButton {
            text: qsTr("Resetare parola")
            Layout.alignment: Qt.AlignRight
            onClicked: {
                // forgot password logic
            }
        }
        */
    }

    Timer {
        id: delayTimer
        interval: 600 // miliseconds delay before starting animation
        running: false
        onTriggered: {
            // fade out animation after delay
            fadeOutAnimation.start();
            // set after starting the animation
            loginPage.closing = true;
        }
    }

    // fading out animation
    NumberAnimation {
        id: fadeOutAnimation
        target: loginPage
        property: "opacity"
        to: 0
        duration: 600 // miliseconds until the opacity is done
        easing.type: Easing.InOutQuad // smoothing
        onRunningChanged: {
            if (!running && loginPage.closing) {
                window.close();
            }
        }
    }
}
