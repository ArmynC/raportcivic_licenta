import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Pdf
import Component

QContentPage {
    id: root
    title: qsTr("Ghid Lege 544/2001")

    PdfDocument {
        id: doc
        source: "qrc:/qt/qml/src/assets/pdf/ghid_544.pdf"
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        ListView {
            id: pdfListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: doc.pageModel
            orientation: Qt.Horizontal
            snapMode: ListView.SnapToItem

            delegate: Item {
                width: pdfListView.width
                height: pdfListView.height

                ScrollView {
                    width: parent.width
                    height: parent.height
                    clip: true

                    Rectangle {
                        width: Math.min(parent.width, doc.pageModel.count > 0 ? doc.pageModel.get(index, "width") : parent.width)
                        height: Math.min(parent.height, doc.pageModel.count > 0 ? doc.pageModel.get(index, "height") : parent.height)
                        color: "white"

                        PdfPageImage {
                            id: pdfPage
                            anchors.centerIn: parent
                            document: doc
                            currentFrame: index
                            asynchronous: true
                            fillMode: Image.PreserveAspectFit
                            sourceSize.width: doc.pageModel.count > 0 ? doc.pageModel.get(index, "width") : parent.width
                            sourceSize.height: doc.pageModel.count > 0 ? doc.pageModel.get(index, "height") : parent.height
                        }
                    }
                }
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter

            QIconButton {
                id: prevButton
                iconSource: FluentIcons.CaretLeftSolid8
                iconSize: 15
                text: qsTr("Inapoi")
                display: Button.TextUnderIcon
                onClicked: pdfListView.decrementCurrentIndex()
                enabled: pdfListView.currentIndex > 0
            }

            QIconButton {
                id: nextButton
                iconSource: FluentIcons.CaretRightSolid8
                iconSize: 15
                text: qsTr("Inainte")
                display: Button.TextUnderIcon
                enabled: pdfListView.currentIndex < pdfListView.count - 1
                onClicked: pdfListView.incrementCurrentIndex()
            }
        }
    }
}
