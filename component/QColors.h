#ifndef QCOLORS_H
#define QCOLORS_H

#include <QObject>
#include <QtQml/qqml.h>

#include "QAccentColor.h"
#include "stdafx.h"
#include "singleton.h"

/**
 * @brief The QColors class
 */
class QColors : public QObject
{
    Q_OBJECT
    Q_PROPERTY_AUTO(QColor,Transparent);
    Q_PROPERTY_AUTO(QColor,Black);
    Q_PROPERTY_AUTO(QColor,White);
    Q_PROPERTY_AUTO(QColor,Grey10);
    Q_PROPERTY_AUTO(QColor,Grey20);
    Q_PROPERTY_AUTO(QColor,Grey30);
    Q_PROPERTY_AUTO(QColor,Grey40);
    Q_PROPERTY_AUTO(QColor,Grey50);
    Q_PROPERTY_AUTO(QColor,Grey60);
    Q_PROPERTY_AUTO(QColor,Grey70);
    Q_PROPERTY_AUTO(QColor,Grey80);
    Q_PROPERTY_AUTO(QColor,Grey90);
    Q_PROPERTY_AUTO(QColor,Grey100);
    Q_PROPERTY_AUTO(QColor,Grey110);
    Q_PROPERTY_AUTO(QColor,Grey120);
    Q_PROPERTY_AUTO(QColor,Grey130);
    Q_PROPERTY_AUTO(QColor,Grey140);
    Q_PROPERTY_AUTO(QColor,Grey150);
    Q_PROPERTY_AUTO(QColor,Grey160);
    Q_PROPERTY_AUTO(QColor,Grey170);
    Q_PROPERTY_AUTO(QColor,Grey180);
    Q_PROPERTY_AUTO(QColor,Grey190);
    Q_PROPERTY_AUTO(QColor,Grey200);
    Q_PROPERTY_AUTO(QColor,Grey210);
    Q_PROPERTY_AUTO(QColor,Grey220);
    Q_PROPERTY_AUTO(QAccentColor*,Yellow);
    Q_PROPERTY_AUTO(QAccentColor*,Orange);
    Q_PROPERTY_AUTO(QAccentColor*,Red);
    Q_PROPERTY_AUTO(QAccentColor*,Magenta);
    Q_PROPERTY_AUTO(QAccentColor*,Purple);
    Q_PROPERTY_AUTO(QAccentColor*,Blue);
    Q_PROPERTY_AUTO(QAccentColor*,Teal);
    Q_PROPERTY_AUTO(QAccentColor*,Green);
    QML_NAMED_ELEMENT(QColors)
    QML_SINGLETON
private:
    explicit QColors(QObject *parent = nullptr);
public:
    SINGLETON(QColors)
    Q_INVOKABLE QAccentColor* createAccentColor(QColor primaryColor);
    static QColors *create(QQmlEngine *qmlEngine, QJSEngine *jsEngine){return getInstance();}
};

#endif // QCOLORS_H
