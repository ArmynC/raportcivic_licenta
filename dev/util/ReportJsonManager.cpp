#include "ReportJsonManager.h"
#include "ReportBridge.h"
#include <QFile>
#include <QJsonDocument>
#include <QJsonArray>
#include <QDebug>

ReportJsonManager::ReportJsonManager(QObject *parent) : QObject(parent) {}

QJsonObject ReportJsonManager::readJsonObject(const QString& fileName) {
    return readJsonObjectPrivate(fileName);
}

QString ReportJsonManager::generateReport(int mainTemplateId) {
    QString report;
    QString mainTemplateFile;

    // Map the ID to corresponding templates
    switch (mainTemplateId) {
    case 1:
        mainTemplateFile = ":/qt/qml/src/assets/data/report_templates/car_park_sidewalk.json";
        break;
    case 2:
        mainTemplateFile = ":/qt/qml/src/assets/data/report_templates/bollard_request.json";
        break;
    case 3:
        mainTemplateFile = ":/qt/qml/src/assets/data/report_templates/street_dogs.json";
        break;
    case 4:
        mainTemplateFile = ":/qt/qml/src/assets/data/report_templates/green_space.json";
        break;
    case 5:
        mainTemplateFile = ":/qt/qml/src/assets/data/report_templates/building_documents.json";
        break;
    default:
        qDebug() << "Invalid template ID";
        return QString();
    }

    // Read the main template file
    QJsonObject mainTemplateJson = readJsonObject(mainTemplateFile);
    if (mainTemplateJson.isEmpty()) {
        qDebug() << "Failed to read main template file:" << mainTemplateFile;
        return QString();
    }

    // Read the sub-modules
    QJsonObject introductionJson = readJsonObject(":/qt/qml/src/assets/data/report_templates/reusable/introduction.json");
    QJsonObject attachmentJson = readJsonObject(":/qt/qml/src/assets/data/report_templates/reusable/attachment.json");
    QJsonObject endingJson = readJsonObject(":/qt/qml/src/assets/data/report_templates/reusable/ending.json");
    QJsonObject locationJson = readJsonObject(":/qt/qml/src/assets/data/report_templates/reusable/location.json");
    QJsonObject og27Json = readJsonObject(":/qt/qml/src/assets/data/report_templates/reusable/og27.json");
    QJsonObject law544Json = readJsonObject(":/qt/qml/src/assets/data/report_templates/reusable/l544_2001.json");

    ReportBridge& data = ReportBridge::getInstance();

    // Process the main template based on the data and sub-modules
    QJsonArray mainTemplateArray = mainTemplateJson.value("template").toArray();
    for (const QJsonValue& value : mainTemplateArray) {
        QString section = value.toString();

        // Replace placeholders in the section
        section = section.replace("{{introduction}}", introductionJson.value("content").toString().replace("{{date}}", data.currentDate()));
        section = section.replace("{{gender_text}}", data.genderText());
        section = section.replace("{{last_name}}", data.lastName());
        section = section.replace("{{first_name}}", data.firstName());
        section = section.replace("{{county}}", data.county());
        section = section.replace("{{city}}", data.city());
        section = section.replace("{{street_name}}", data.street());
        section = section.replace("{{event_address}}", data.eventLocation());

        // check if the string are not empty before replacing placeholders
        QString addressComponents = "";

        // create the address components string
        if (!data.building().isEmpty()) {
            addressComponents += data.building();
        }
        if (!data.entrance().isEmpty()) {
            if (!addressComponents.isEmpty()) {
                addressComponents += ", ";
            }
            addressComponents += data.entrance();
        }
        if (!data.apartment().isEmpty()) {
            if (!addressComponents.isEmpty()) {
                addressComponents += ", ";
            }
            addressComponents += data.apartment();
        }

        // replace the placeholders in the section
        if (!addressComponents.isEmpty()) {
            section = section.replace("{{building}} {{entrance}} {{apartment}}", addressComponents);
        } else {
            section = section.replace("{{building}} {{entrance}} {{apartment}}", "");

            // comma handle
            section = section.replace(", ,", ",");
            section = section.replace(",  ,", ",");
            section = section.replace(",,", ",");
            section = section.replace(" ,", "");
        }

        // add additional description if provided
        if (section.contains("{{descriere_aditionala}}") && !data.description().isEmpty()) {
            section = section.replace("{{descriere_aditionala}}", "\n\n" + data.description());
        } else {
            section = section.remove("{{descriere_aditionala}}");
        }

        // add attachment sub-module if files were attached
        if (section.contains("{{attachment}}") && (data.hasAttachedImages() || data.hasAttachedDocuments())) {
            QString attachmentText = attachmentJson.value("content").toString();
            if (data.hasAttachedImages() && data.hasAttachedDocuments()) {
                attachmentText = attachmentText.replace("{{image}}", "imagini").replace("{{files}}", "si documente");
            } else if (data.hasAttachedImages()) {
                attachmentText = attachmentText.replace("{{image}}", "imagini").replace("si {{files}}", "");
            } else {
                attachmentText = attachmentText.replace("{{image}} si", "").replace("{{files}}", "documente");
            }
            section = section.replace("{{attachment}}", attachmentText);
        } else {
            section = section.remove("{{attachment}}");
        }

        // add location sub-module if a gmaps link is available
        if (section.contains("{{location}}") && !data.googleMapsLink().isEmpty()) {
            section = section.replace("{{location}}", "\n\n" + locationJson.value("content").toString().replace("{{gmaps}}", data.googleMapsLink()));
        } else {
            section = section.remove("{{location}}");
        }

        // add law sub-modules if present in the template
        if (section.contains("{{og27}}")) {
            section = section.replace("{{og27}}", og27Json.value("content").toString());
        } else {
            section = section.remove("{{og27}}");
        }
        if (section.contains("{{l544_2001}}")) {
            section = section.replace("{{l544_2001}}", law544Json.value("content").toString());
        } else {
            section = section.remove("{{l544_2001}}");
        }

        // add the ending submodule
        section = section.replace("{{ending}}", endingJson.value("content").toString());

        // add the processed section to the report
        report += section;
    }

    // add the ending submodule if doesn't exist
    if (!report.contains(endingJson.value("content").toString())) {
        report += "\n\n" + endingJson.value("content").toString();
    }

    // qDebug() << "Generated Report: " << report;

    return report;
}

QJsonObject ReportJsonManager::readJsonObjectPrivate(const QString& fileName) {
    QFile file(fileName);
    if (!file.open(QFile::ReadOnly)) {
        qDebug() << "Failed to open file:" << fileName;
        return QJsonObject();
    }

    QJsonParseError error;
    QJsonDocument doc = QJsonDocument::fromJson(file.readAll(), &error);
    if (error.error != QJsonParseError::NoError) {
        qDebug() << "Failed to parse JSON:" << error.errorString();
        return QJsonObject();
    }

    return doc.object();
}
