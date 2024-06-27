#ifndef QTEXTSTYLE_H
#define QTEXTSTYLE_H

#include <QObject>
#include <QtQml/qqml.h>
#include <QFont>
#include "stdafx.h"
#include "singleton.h"

/**
 * @brief The QTextStyle class
 */
class QTextStyle : public QObject
{
    Q_OBJECT
public:
    Q_PROPERTY_AUTO(QString,family)
    Q_PROPERTY_AUTO(QFont,Caption);
    Q_PROPERTY_AUTO(QFont,Body);
    Q_PROPERTY_AUTO(QFont,BodyStrong);
    Q_PROPERTY_AUTO(QFont,Subtitle);
    Q_PROPERTY_AUTO(QFont,Title);
    Q_PROPERTY_AUTO(QFont,TitleLarge);
    Q_PROPERTY_AUTO(QFont,Display);
    QML_NAMED_ELEMENT(QTextStyle)
    QML_SINGLETON
private:
    explicit QTextStyle(QObject *parent = nullptr);
public:
    SINGLETON(QTextStyle)
    static QTextStyle *create(QQmlEngine *qmlEngine, QJSEngine *jsEngine){return getInstance();}
};

#endif // QTEXTSTYLE_H
