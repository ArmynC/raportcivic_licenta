#include "JsonParser.h"
#include <QFile>
#include <QJsonParseError>
#include <QDebug>

JsonParser::JsonParser(QObject *parent) : QObject(parent)
{
    jsonData = loadJson().object();
}

QJsonDocument JsonParser::loadJson()
{
    QFile file(":/qt/qml/src/assets/data/judete.json");
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "Couldn't open the file.";
        return QJsonDocument(); // yield empty
    }

    QByteArray fileData = file.readAll();
    file.close();

    QJsonParseError parseError;
    QJsonDocument document = QJsonDocument::fromJson(fileData, &parseError);  // parse json data
    if (parseError.error != QJsonParseError::NoError) {
        qWarning() << "Error parsing JSON:" << parseError.errorString();
        return QJsonDocument();  // yield empty
    }

    return document;  // parsed data
}

// retrieve all counties
QStringList JsonParser::getAllCounties()
{
    QStringList counties;  // store county names
    QJsonArray countyArray = jsonData.value("judete").toArray();  // extract array of counties
    for (const QJsonValue &value : countyArray) {
        QJsonObject countyObject = value.toObject();  // object convert
        counties.append(countyObject.value("nume").toString());
    }
    return counties;
}

// retrieve cities by county name
QStringList JsonParser::getCitiesByCounty(const QString &countyName)
{
    QStringList cities;  // store city names
    QJsonArray countyArray = jsonData.value("judete").toArray();  // extract array of counties
    for (const QJsonValue &value : countyArray) {
        QJsonObject countyObject = value.toObject();  // object convert
        if (countyObject.value("nume").toString() == countyName) {  // check county name
            QJsonArray localitiesArray = countyObject.value("localitati").toArray();  // extract array of localities
            for (const QJsonValue &localityValue : localitiesArray) {
                QJsonObject localityObject = localityValue.toObject();  // object convert
                QString cityName = localityObject.value("nume").toString();  // get city name
                if (localityObject.contains("comuna")) {  // match if locality has a commune
                    cityName += " (" + localityObject.value("comuna").toString() + ")";  // add additional context
                }
                cities.append(cityName);  // append the city name to list
            }
            break;
        }
    }
    return cities;
}
