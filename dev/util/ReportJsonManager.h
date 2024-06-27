#ifndef REPORTJSONMANAGER_H
#define REPORTJSONMANAGER_H

#include <QObject>
#include <QJsonObject>
#include <QString>

class ReportJsonManager : public QObject
{
    Q_OBJECT

public:
    explicit ReportJsonManager(QObject *parent = nullptr);

    static QJsonObject readJsonObject(const QString& fileName);
    Q_INVOKABLE static QString generateReport(int mainTemplateId);

private:
    static QJsonObject readJsonObjectPrivate(const QString& fileName);
};

#endif // REPORTJSONMANAGER_H
