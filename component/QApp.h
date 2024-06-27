#ifndef QAPP_H
#define QAPP_H

#include <QObject>
#include <QWindow>
#include <QtQml/qqml.h>
#include <QQmlContext>
#include <QJsonObject>
#include <QQmlEngine>
#include <QTranslator>
#include <QQuickWindow>
#include "stdafx.h"
#include "singleton.h"

class QApp : public QObject
{
    Q_OBJECT
    Q_PROPERTY_AUTO(bool,useSystemAppBar);
    Q_PROPERTY_AUTO(QString,windowIcon);
    Q_PROPERTY_AUTO(QLocale,locale);
    QML_NAMED_ELEMENT(QApp)
    QML_SINGLETON
private:
    explicit QApp(QObject *parent = nullptr);
    ~QApp();
public:
    SINGLETON(QApp)
    static QApp *create(QQmlEngine *qmlEngine, QJSEngine *jsEngine){return getInstance();}
    Q_INVOKABLE void init(QObject *target,QLocale locale = QLocale::system());
private:
    QQmlEngine *_engine;
    QTranslator* _translator = nullptr;
};

#endif // QAPP_H
