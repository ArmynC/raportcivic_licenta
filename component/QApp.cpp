#include "QApp.h"

#include <QQmlEngine>
#include <QGuiApplication>
#include <QQmlContext>
#include <QQuickItem>
#include <QTimer>
#include <QUuid>
#include <QFontDatabase>
#include <QClipboard>
#include <QTranslator>

QApp::QApp(QObject *parent):QObject{parent}{
    useSystemAppBar(false);
}

QApp::~QApp(){
}

void QApp::init(QObject *target,QLocale locale){
    _locale = locale;
    _engine = qmlEngine(target);
    _translator = new QTranslator(this);
    qApp->installTranslator(_translator);
    const QStringList uiLanguages = _locale.uiLanguages();
    for (const QString &name : uiLanguages) {
        const QString baseName = "component_" + QLocale(name).name();
        if (_translator->load(":/qt/qml/Component/i18n/"+ baseName)) {
            _engine->retranslate();
            break;
        }
    }
}
