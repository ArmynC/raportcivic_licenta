#ifndef URLOPENER_H
#define URLOPENER_H

#include <QObject>
#include <QString>
#include "../singleton.h"

class UrlOpener : public QObject, public Singleton<UrlOpener>
{
    Q_OBJECT
    friend class Singleton<UrlOpener>;

public:
    Q_INVOKABLE bool openUrl(const QString &url);

private:
    UrlOpener() : QObject(nullptr) {}
};

#endif // URLOPENER_H
