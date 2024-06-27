#ifndef QMLBRIDGE_H
#define QMLBRIDGE_H

#include <QObject>
#include "dev/singleton.h"

class QmlBridge : public QObject, public Singleton<QmlBridge>
{
    Q_OBJECT

    friend class Singleton<QmlBridge>; // permit singleton access into protected

public:
    static QmlBridge& getInstance();

signals:
    void logoutSignal();
    void loginSignal();
    void accountSettingsSignal();

public slots:
    void logout();
    void login();
    void accountSettings();

private:
    explicit QmlBridge(QObject *parent = nullptr);
    ~QmlBridge();
};

#endif // QMLBRIDGE_H
