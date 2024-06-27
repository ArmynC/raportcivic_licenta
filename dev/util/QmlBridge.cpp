#include "QmlBridge.h"

QmlBridge::QmlBridge(QObject *parent) : QObject(parent) {}

QmlBridge::~QmlBridge() {}

QmlBridge& QmlBridge::getInstance()
{
    return Singleton<QmlBridge>::getInstance();
}

void QmlBridge::logout()
{
    emit logoutSignal();
}

void QmlBridge::login()
{
    emit loginSignal();
}

void QmlBridge::accountSettings()
{
    emit accountSettingsSignal();
}
