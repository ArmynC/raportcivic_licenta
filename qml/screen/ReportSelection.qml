import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Component
import module

QContentPage {
    id: root
    title: qsTr("Selectare sablon")

    property int reportId: 0

    Component.onCompleted: {
        resetReportBridge()
    }

    QFrame {
        id: layout_controls
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            topMargin: 20
        }
        height: 60

        QText {
            anchors {
                left: parent.left
                leftMargin: 10
                verticalCenter: parent.verticalCenter
            }
            text: qsTr("Alege tipul de sesizare pe care doresti sa il generezi.")
            font: QTextStyle.BodyStrong
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }
    }

    QTableView {
        id: table_view
        anchors {
            left: parent.left
            right: parent.right
            top: layout_controls.bottom
            bottom: parent.bottom
        }
        anchors.topMargin: 5
        columnSource: [
            {
                title: qsTr("Imagine"),
                dataIndex: 'image',
                width: 100,
                readOnly: true
            },
            {
                title: qsTr("Descriere"),
                dataIndex: 'description',
                width: 200,
                minimumWidth: 100,
                maximumWidth: 300,
                readOnly: true
            },
            {
                title: qsTr("Actiune"),
                dataIndex: 'action',
                width: 160,
                minimumWidth: 160,
                maximumWidth: 160,
                readOnly: true
            }
        ]
        dataSource: [
            {
                image: table_view.customItem(com_image, { image: "qrc:/qt/qml/src/assets/img/circle/c3.png" }),
                description:  qsTr("Masina parcata trotuar"),
                action: table_view.customItem(com_action, { reportId: "1" }),
                _minimumHeight: 50
            },
            {
                image: table_view.customItem(com_image, { image: "qrc:/qt/qml/src/assets/img/circle/c4.png" }),
                description: qsTr("Amenajare stalpisori trotuar"),
                action: table_view.customItem(com_action, { reportId: "2" }),
                _minimumHeight: 50
            },
            {
                image: table_view.customItem(com_image, { image: "qrc:/qt/qml/src/assets/img/circle/c5.png" }),
                description: qsTr("Caini pe strada <fara stapan>"),
                action: table_view.customItem(com_action, { reportId: "3" }),
                _minimumHeight: 50
            },
            {
                image: table_view.customItem(com_image, { image: "qrc:/qt/qml/src/assets/img/circle/c6.png" }),
                description: qsTr("Alveole/spatii verzi goale"),
                action: table_view.customItem(com_action, { reportId: "4" }),
                _minimumHeight: 50
            },
            {
                image: table_view.customItem(com_image, { image: "qrc:/qt/qml/src/assets/img/circle/c7.png" }),
                description: qsTr("Documente autorizare cladire"),
                action: table_view.customItem(com_action, { reportId: "5" }),
                _minimumHeight: 50
            }
        ]
    }

    Component {
        id: com_image
        Item {
            QClip {
                anchors.centerIn: parent
                width: 40
                height: 40
                radius: [20, 20, 20, 20]
                Image {
                    anchors.fill: parent
                    source: options.image
                    sourceSize: Qt.size(80, 80)
                }
            }
        }
    }

    Component {
        id: com_action
        Item {
            QProgressButton {
                id: selectTypeBtn
                text: qsTr("Selecteaza")
                anchors.centerIn: parent

                Timer {
                    id: timer
                    interval: 60 // fake animation delay
                    repeat: true
                    onTriggered: {
                        selectTypeBtn.progress += 0.1;
                        if (selectTypeBtn.progress >= 1) {
                            timer.stop();
                            ReportBridge.selectedReportId = options.reportId; // save the report id
                            nav_view.push("qrc:/qt/qml/src/qml/screen/ReportData.qml")
                        }
                    }
                }

                onClicked: {
                    selectTypeBtn.progress = 0; // not actioned
                    timer.start();
                }
            }
        }
    }

    // clear reportbridge stored local session data
    function resetReportBridge() {
        ReportBridge.selectedReportId = -1
        ReportBridge.firstName = ""
        ReportBridge.lastName = ""
        ReportBridge.personalNumericCode = ""
        ReportBridge.contactEmail = ""
        ReportBridge.phone = ""
        ReportBridge.county = ""
        ReportBridge.city = ""
        ReportBridge.street = ""
        ReportBridge.building = ""
        ReportBridge.entrance = ""
        ReportBridge.apartment = ""
        ReportBridge.description = ""
        ReportBridge.eventLocation = ""
        ReportBridge.currentDate = ""
        ReportBridge.genderText = ""
        ReportBridge.googleMapsLink = ""
        ReportBridge.reportText = ""
    }
}
