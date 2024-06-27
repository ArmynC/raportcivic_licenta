import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Pdf
import Component

QContentPage {
    id: root
    title: qsTr("Ghid cazuri")

    PdfDocument {
        id: doc
        source: "qrc:/qt/qml/src/assets/pdf/ghid_cazuri.pdf"
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
                width: Math.min(pdfListView.width, doc.pageModel.count > 0 ? doc.pageModel.get(0, "width") : pdfListView.width)
                height: Math.min(pdfListView.height, doc.pageModel.count > 0 ? doc.pageModel.get(0, "height") : pdfListView.height)

                Rectangle {
                    anchors.fill: parent
                    color: "white"

                    PdfPageImage {
                        id: pdfPage
                        anchors.centerIn: parent
                        document: doc
                        currentFrame: index
                        asynchronous: true
                        fillMode: Image.PreserveAspectFit
                        sourceSize.width: doc.pageModel.count > 0 ? doc.pageModel.get(0, "width") : pdfListView.width
                        sourceSize.height: doc.pageModel.count > 0 ? doc.pageModel.get(0, "height") : pdfListView.height
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
