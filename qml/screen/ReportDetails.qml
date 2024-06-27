import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtLocation
import QtPositioning
import QtQuick.Dialogs
import Qt.labs.platform
import Component
import module

QScrollablePage {
    id: root

    title: qsTr("Detalii suplimentare")

    property bool externalWay: true
    property bool hasValidExif: false

    ExifExtractor {
        id: exifExtractor
    }

    ReportJsonManager {
        id: reportJsonManager
    }

    ListModel {
        id: validExifFiles
    }

    // generate current date on dd.mm.yyyy format
    function setCurrentDate() {
        var currentDate = new Date()
        var day = ("0" + currentDate.getDate()).slice(-2)
        var month = ("0" + (currentDate.getMonth() + 1)).slice(-2)
        var year = currentDate.getFullYear()
        var formattedDate = day + "." + month + "." + year
        ReportBridge.currentDate = formattedDate
        console.log(ReportBridge.currentDate)
    }

    // set gender text based on CNP
    function setGenderText() {
        var cnp = ReportBridge.personalNumericCode
        if(cnp.length === 13) {
            var genderDigit = parseInt(cnp.charAt(0))
            if(genderDigit % 2 === 1) {
                ReportBridge.genderText = "Subsemnatul"
            } else {
                ReportBridge.genderText = "Subsemnata"
            }
        } else {
            ReportBridge.genderText = "Cetateanul"
        }
    }

    function generateGMapsLink(latitude, longitude) {
        // gmaps link with coordinates
        var mapsLink = "https://www.google.com/maps/@?api=1&map_action=map&center=" + latitude + "," + longitude + "&zoom=18"

        // street view
        var streetViewLink = "https://www.google.com/maps/@?api=1&map_action=pano&viewpoint=" + latitude + "," + longitude + "&heading=-45&pitch=38&fov=80"

        ReportBridge.googleMapsLink = streetViewLink

        console.log("Generated Google Maps link:", mapsLink)
        console.log("Generated Google Street View link:", streetViewLink)
    }

    function generateReportText() {
        const mainTemplateId = ReportBridge.selectedReportId
        if(mainTemplateId !== -1) {
            // generate text
            var generatedText = reportJsonManager.generateReport(mainTemplateId)

            ReportBridge.reportText = generatedText
        } else {
            console.log("Invalid template ID at generate")
        }
    }

    function submitExternalReport() {
        // Clear previous attachments
        ReportBridge.setAttachedImages([])
        ReportBridge.setAttachedDocuments([])

        // Add media files as attachedImages
        var mediaFiles = []
        for(var i = 0; i < mediaFilesList.model.count; i++) {
            mediaFiles.push(mediaFilesList.model.get(i).filePath)
        }
        ReportBridge.setAttachedImages(mediaFiles)

        // Add documents as attachedDocuments
        var documentFiles = []
        for(var j = 0; j < documentsList.model.count; j++) {
            documentFiles.push(documentsList.model.get(j).filePath)
        }
        ReportBridge.setAttachedDocuments(documentFiles)

        // make use of generator
        generateReportText()

        // access the generated text
        var reportText = ReportBridge.reportText
        if(reportText === "") {
            console.log("Unable to access the pre-defined text report")
            return
        }

        // title
        var subject = "Sesizare"

        // content message
        var body = reportText

        // encode in url the subject and body
        var encodedSubject = encodeURIComponent(subject)
        var encodedBody = encodeURIComponent(body)

        // set the mailto link
        var mailtoLink = "mailto:?subject=" + encodedSubject + "&body=" + encodedBody

        // combine media files and documents into a single array
        var attachments = mediaFiles.concat(documentFiles)

        // load the attachments (if client supports)
        if(attachments.length > 0) {
            mailtoLink += "&attach=" + encodeURIComponent(attachments.join(","))
        }

        // open the mailto using qdesktopservices
        if(UrlOpener.openUrl(mailtoLink)) {
            console.log("Opening the web/client email...")
        } else {
            console.log("Unable to open the web/client email")
        }
    }

    Component.onCompleted: {
        setCurrentDate()
        setGenderText()
    }

    QFrame {
        Layout.fillWidth: true
        Layout.topMargin: 20
        Layout.preferredHeight: 36 + description.height + multiine_description.height + descriptionMultiSwitch.height
        padding: 10

        ColumnLayout {
            anchors.fill: parent
            spacing: 10

            QText {
                id: description
                text: qsTr("Adauga o descriere aditionala")
                font: QTextStyle.BodyStrong
            }

            QMultilineTextBox {
                id: multiine_description
                placeholderText: qsTr("Descriere (max. 490)")
                Layout.preferredWidth: 180
                Layout.preferredHeight: 160
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                characterLimit: 490
                disabled: descriptionMultiSwitch.checked
                text: ReportBridge.description
                onTextChanged: ReportBridge.description = text
            }

            QToggleSwitch {
                id: descriptionMultiSwitch
                Layout.alignment: Qt.AlignRight | Qt.AlignTop
                text: qsTr("Dezactiveaza")
                onCheckedChanged: {
                    if(checked) {
                        ReportBridge.description = ""
                        multiine_description.text = ""
                        multiine_description.placeholderText = ""
                    } else {
                        multiine_description.placeholderText = qsTr("Descriere (max. 490)")
                    }
                }
            }
        }
    }

    QFrame {
        Layout.fillWidth: true
        padding: 10

        ColumnLayout {
            spacing: 10

            QText {
                text: qsTr("Metoda transmitere")
                font: QTextStyle.BodyStrong
            }

            ButtonGroup {
                id: submissionMethodGroup
                buttons: [externalRadioButton, internalRadioButton]
                exclusive: true
                onClicked: {
                    if(submissionMethodGroup.checkedButton === null) {
                        externalRadioButton.checked = true
                    }
                }
            }

            QRadioButton {
                id: externalRadioButton
                text: qsTr("Redirectionare externa")
                checked: true
            }

            QRadioButton {
                id: internalRadioButton
                text: qsTr("Generare text")
            }
        }
    }

    QFrame {
        Layout.fillWidth: true
        padding: 10
        visible: externalRadioButton.checked

        ColumnLayout {
            spacing: 10

            QText {
                text: qsTr("Atasare fisiere")
                font: QTextStyle.BodyStrong
            }

            QButton {
                text: qsTr("Incarca fisiere media")
                onClicked: imageVideoDialog.open()
            }

            FileDialog {
                id: imageVideoDialog
                title: qsTr("Selecteaza imagini sau videoclipuri")
                // image format
                nameFilters: ["Image files (*.jpg *.png *.gif *.bmp)", "Video files (*.mp4 *.avi *.mov)"]
                onAccepted: {
                    var filePath = imageVideoDialog.file.toString().replace("file:///", "")
                    mediaFilesList.model.append({
                        "fileName": filePath.split('/').pop()
                    })

                    // extract lat and long string
                    var exifLocation = exifExtractor.extractExifLocation(filePath)
                    var latitudeMatch = exifLocation.match(/Latitude:\s*(-?\d+(\.\d+)?)/)
                    var longitudeMatch = exifLocation.match(/Longitude:\s*(-?\d+(\.\d+)?)/)

                    if(latitudeMatch && longitudeMatch) {
                        var latitude = parseFloat(latitudeMatch[1])
                        var longitude = parseFloat(longitudeMatch[1])

                        if(latitude !== 0 && longitude !== 0) {
                            validExifFiles.append({
                                "filePath": filePath,
                                "latitude": latitude,
                                "longitude": longitude
                            })
                        } else {
                            console.log("Invalid EXIF coordinates (0, 0) in:", filePath)
                        }
                    } else {
                        console.log("No correct EXIF in:", filePath)
                    }
                }
            }

            ListView {
                id: mediaFilesList
                Layout.fillWidth: true
                Layout.preferredHeight: contentHeight
                model: ListModel {}
                delegate: QText {
                    text: fileName
                    font.italic: true
                }
                visible: model.count > 0
            }

            QButton {
                text: qsTr("Incarca documente")
                onClicked: documentDialog.open()
            }

            FileDialog {
                id: documentDialog
                title: qsTr("Selecteaza documente")
                // document format
                nameFilters: ["Text files (*.txt)", "PDF files (*.pdf)", "Word files (*.doc *.docx)", "Excel files (*.xls *.xlsx)"]
                onAccepted: {
                    var filePath = documentDialog.file.toString().replace("file:///", "")
                    documentsList.model.append({
                        "fileName": filePath.split('/').pop()
                    })
                }
            }

            ListView {
                id: documentsList
                Layout.fillWidth: true
                Layout.preferredHeight: contentHeight
                model: ListModel {}
                delegate: QText {
                    text: fileName
                    font.italic: true
                }
                visible: model.count > 0
            }
        }
    }

    QFrame {
        Layout.fillWidth: true
        padding: 10

        ColumnLayout {
            spacing: 10

            QGroupBox {
                title: qsTr("Adresa eveniment")

                ColumnLayout {
                    spacing: 10

                    ButtonGroup {
                        id: addressButtonGroup
                        exclusive: true
                    }

                    QRadioButton {
                        id: noAddressCheckbox
                        text: qsTr("Fara adresa")
                        checked: true
                        ButtonGroup.group: addressButtonGroup
                        onClicked: {
                            ReportBridge.eventLocation = ""
                            if(!checked) {
                                checked = true
                            }
                        }
                    }

                    QRadioButton {
                        id: exifAddressCheckbox
                        text: qsTr("Extrage EXIF")
                        checked: false
                        visible: validExifFiles.count > 0
                        ButtonGroup.group: addressButtonGroup
                        onClicked: {
                            if(!checked) {
                                checked = true
                            }
                        }
                    }

                    QRadioButton {
                        id: mapAddressCheckbox
                        text: qsTr("Pin pe harta")
                        checked: false
                        ButtonGroup.group: addressButtonGroup
                        onClicked: {
                            if(!checked) {
                                checked = true
                            }
                        }
                    }

                    QRadioButton {
                        id: manualAddressCheckbox
                        text: qsTr("Introducere manuala")
                        checked: false
                        ButtonGroup.group: addressButtonGroup
                        onClicked: {
                            if(!checked) {
                                checked = true
                            }
                        }
                    }
                }
            }

            ColumnLayout {
                spacing: 10
                visible: manualAddressCheckbox.checked

                QTextBox {
                    id: manualAddressField
                    Layout.preferredWidth: 170
                    placeholderText: qsTr("Adresa")
                }

                QButton {
                    text: qsTr("Salveaza adresa")
                    onClicked: {
                        ReportBridge.eventLocation = manualAddressField.text
                    }
                }
            }

            QText {
                id: savedAddressText
                text: qsTr("Adresa inregistrata: ") + ReportBridge.eventLocation
                font.bold: true
                Layout.fillWidth: true
                wrapMode: Text.Wrap
                visible: {
                    if(noAddressCheckbox.checked) {
                        return false
                    } else if(exifAddressCheckbox.checked && ReportBridge.eventLocation !== "") {
                        return true
                    } else if(mapAddressCheckbox.checked && ReportBridge.eventLocation !== "") {
                        return true
                    } else if(manualAddressCheckbox.checked && ReportBridge.eventLocation !== "") {
                        return true
                    } else {
                        return false
                    }
                }
            }

            ColumnLayout {
                spacing: 10

                QText {
                    text: qsTr("Ce fisier defineste locatia?")
                    visible: exifAddressCheckbox.checked
                }

                ListView {
                    id: validExifFilesList
                    Layout.fillWidth: true
                    Layout.preferredHeight: contentHeight
                    model: validExifFiles
                    delegate: RowLayout {
                        spacing: 10

                        QRadioButton {
                            id: fileRadioButton
                            checked: false
                            ButtonGroup.group: validExifFilesGroup
                            onCheckedChanged: {
                                if(checked) {
                                    var selectedFile = validExifFiles.get(index)
                                    var coordinates = QtPositioning.coordinate(selectedFile.latitude, selectedFile.longitude)
                                    convertCoordinatesToAddress(coordinates)
                                    generateGMapsLink(selectedFile.latitude, selectedFile.longitude)
                                }
                            }
                        }

                        QText {
                            text: validExifFiles.get(index).filePath.split('/').pop()
                            font.italic: true
                        }
                    }
                    visible: exifAddressCheckbox.checked
                }

                ButtonGroup {
                    id: validExifFilesGroup
                    exclusive: true
                }
            }
        }
    }

    QFrame {
        Layout.fillWidth: true
        padding: 10
        visible: mapAddressCheckbox.checked

        ColumnLayout {
            spacing: 10
            anchors.fill: parent

            QFrame {
                Layout.fillWidth: true
                padding: 10
                visible: mapAddressCheckbox.checked
                ColumnLayout {
                    spacing: 10
                    anchors.fill: parent

                    Map {
                        id: map
                        Layout.fillWidth: true
                        Layout.preferredHeight: 400
                        plugin: mapPlugin
                        center: QtPositioning.coordinate(44.4268, 26.1025) // bucharest coordinates
                        zoomLevel: 12
                        property
                        var startCentroid

                        Plugin {
                            id: mapPlugin
                            name: "osm"

                            PluginParameter {
                                name: "osm.mapping.custom.host"
                                value: "https://tile.thunderforest.com/atlas/%z/%x/%y.png?apikey=ac5a00cde28a49a897b17b3eca157122"
                            }

                            PluginParameter {
                                name: "osm.mapping.providersrepository.disabled"
                                value: "true"
                            }

                            PluginParameter {
                                name: "osm.mapping.providersrepository.address"
                                value: "http://maps-redirect.qt.io/osm/5.8/"
                            }
                        }

                        onSupportedMapTypesChanged: {
                            map.activeMapType = map.supportedMapTypes[map.supportedMapTypes.length - 1]
                        }

                        onCenterChanged: {
                            console.log("Center changed to:", map.center.latitude, map.center.longitude)
                            selectedAddress.text = qsTr("Lat: ") + map.center.latitude.toFixed(6) + ", Lon: " + map.center.longitude.toFixed(6)
                        }

                        PinchHandler {
                            id: pinch
                            target: null
                            onActiveChanged: if(active) {
                                map.startCentroid = map.toCoordinate(pinch.centroid.position, false)
                            }
                            onScaleChanged: delta => {
                                map.zoomLevel += Math.log2(delta)
                                map.alignCoordinateToPoint(map.startCentroid, pinch.centroid.position)
                            }
                            onRotationChanged: delta => {
                                map.bearing -= delta
                                map.alignCoordinateToPoint(map.startCentroid, pinch.centroid.position)
                            }
                            grabPermissions: PointerHandler.TakeOverForbidden
                        }

                        WheelHandler {
                            id: wheel
                            acceptedDevices: Qt.platform.pluginName === "cocoa" || Qt.platform.pluginName === "wayland" ? PointerDevice.Mouse | PointerDevice.TouchPad : PointerDevice.Mouse
                            rotationScale: 1 / 120
                            property: "zoomLevel"
                        }

                        DragHandler {
                            id: drag
                            target: null
                            onTranslationChanged: delta => map.pan(-delta.x, -delta.y)
                            cursorShape: Qt.OpenHandCursor
                            onActiveChanged: {
                                drag.cursorShape = active ? Qt.ClosedHandCursor : Qt.OpenHandCursor
                            }
                        }

                        Shortcut {
                            enabled: map.zoomLevel < map.maximumZoomLevel
                            sequence: StandardKey.ZoomIn
                            onActivated: map.zoomLevel = Math.round(map.zoomLevel + 1)
                        }

                        Shortcut {
                            enabled: map.zoomLevel > map.minimumZoomLevel
                            sequence: StandardKey.ZoomOut
                            onActivated: map.zoomLevel = Math.round(map.zoomLevel - 1)
                        }

                        // center dot pin
                        Rectangle {
                            id: mapPin
                            width: 10
                            height: 10
                            color: "green"
                            radius: 5
                            anchors.centerIn: parent
                        }

                        Component.onCompleted: {
                            selectedAddress.text = qsTr("Lat: ") + map.center.latitude.toFixed(6) + ", Lon: " + map.center.longitude.toFixed(6)
                        }
                    }

                    RowLayout {
                        spacing: 10
                        Layout.alignment: Qt.AlignHCenter

                        QIconButton {
                            iconSource: FluentIcons.CalculatorAddition
                            onClicked: map.zoomLevel += 1
                        }

                        QIconButton {
                            iconSource: FluentIcons.CalculatorSubtract
                            onClicked: map.zoomLevel -= 1
                        }
                    }

                    QText {
                        id: selectedAddress
                        text: qsTr("Lat: ") + map.center.latitude.toFixed(6) + ", Lon: " + map.center.longitude.toFixed(6)
                        Layout.fillWidth: true
                        wrapMode: Text.Wrap
                    }

                    QButton {
                        text: qsTr("Inregistreaza coordonate")
                        onClicked: {
                            var latitude = map.center.latitude
                            var longitude = map.center.longitude
                            var coordinates = QtPositioning.coordinate(latitude, longitude)
                            convertCoordinatesToAddress(coordinates)
                            generateGMapsLink(latitude, longitude)
                        }
                    }
                }
            }
        }
    }

    QFrame {
        Layout.fillWidth: true
        padding: 10

        QIconButton {
            text: qsTr("Completare")
            iconSource: FluentIcons.SendFill
            iconSize: 15
            display: Button.TextBesideIcon
            onClicked: {
                if(internalRadioButton.checked) {
                    generateReportText()

                    // navigate to the display page
                    nav_view.push("qrc:/qt/qml/src/qml/screen/ReportDisplay.qml")
                } else {
                    submitExternalReport()
                }
            }
        }
    }

    function convertCoordinatesToAddress(coordinates) {
        var xhr = new XMLHttpRequest();
        var url = "https://nominatim.openstreetmap.org/reverse?format=json&lat=" + coordinates.latitude + "&lon=" + coordinates.longitude;

        console.log("API URL:", url);

        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    try {
                        var response = JSON.parse(xhr.responseText);
                        if (response && response.address) {
                            var address = response.address;
                            var streetName = address.road || address.pedestrian || address.path || "";
                            var houseNumber = address.house_number || "";
                            var fullAddress = streetName + (houseNumber ? " " + houseNumber : "");
                            ReportBridge.eventLocation = fullAddress;
                            console.log("Converted address:", fullAddress);
                        } else {
                            ReportBridge.eventLocation = "";
                            console.log("No address given");
                        }
                    } catch (e) {
                        console.log("Error at response:", e);
                        ReportBridge.eventLocation = "";
                    }
                } else {
                    console.log("Error:", xhr.status, xhr.statusText);
                    ReportBridge.eventLocation = "";
                }
            }
        };

        xhr.open("GET", url);
        xhr.setRequestHeader("User-Agent", "RaportCivic/1.0 (Qt 6.7.1; Ubuntu 24.04)");
        xhr.send();
    }
}
