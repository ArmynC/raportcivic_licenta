#ifndef JSONPARSER_H
#define JSONPARSER_H

#include <QObject>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QStringList>
#include "dev/singleton.h"

class JsonParser : public QObject, public Singleton<JsonParser>
{
    Q_OBJECT
    friend class Singleton<JsonParser>;

public:
    Q_INVOKABLE QStringList getAllCounties();
    Q_INVOKABLE QStringList getCitiesByCounty(const QString &countyName);

private:
    JsonParser(QObject *parent = nullptr);
    QJsonDocument loadJson();
    QJsonObject jsonData;
};

#endif // JSONPARSER_H
