#include "AppVersion.h"

#include <QQmlContext>
#include <QDebug>
#include <QGuiApplication>
#include "build.h"

AppVersion::AppVersion(QObject *parent)
    : QObject{parent}
{
    version(APP_BUILD);
}

void AppVersion::testCrash(){
    auto *crash = reinterpret_cast<volatile int *>(0);
    *crash = 0;
}
