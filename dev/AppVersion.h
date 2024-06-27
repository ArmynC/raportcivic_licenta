#ifndef APPVERSION_H
#define APPVERSION_H

#include <QObject>
#include <QQmlApplicationEngine>
#include "stdafx.h"
#include "singleton.h"

class AppVersion : public QObject, public Singleton<AppVersion>
{
    Q_OBJECT
    Q_PROPERTY_AUTO(QString, version)

private:
    explicit AppVersion(QObject *parent = nullptr);
    friend class Singleton<AppVersion>;

public:
    Q_INVOKABLE void testCrash(); // app crash invoke
};

#endif // APPVERSION_H
