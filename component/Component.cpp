#include "Component.h"

#include <QGuiApplication>
#include "Def.h"
#include "QApp.h"
#include "QColors.h"
#include "QTheme.h"
#include "QTools.h"
#include "QTextStyle.h"
#include "QWatermark.h"
#include "QCaptcha.h"
#include "QTreeModel.h"
#include "QRectangle.h"
#include "QQrCodeItem.h"
#include "QTableSortProxyModel.h"
#include "QFrameless.h"

void Component::registerTypes(QQmlEngine *engine){
    initializeEngine(engine,uri);
    registerTypes(uri);
}

void Component::registerTypes(const char *uri){
}

void Component::initializeEngine(QQmlEngine *engine, const char *uri){
    engine->rootContext()->setContextProperty("QApp",QApp::getInstance());
    engine->rootContext()->setContextProperty("QColors",QColors::getInstance());
    engine->rootContext()->setContextProperty("QTheme",QTheme::getInstance());
    engine->rootContext()->setContextProperty("QTools",QTools::getInstance());
    engine->rootContext()->setContextProperty("QTextStyle",QTextStyle::getInstance());
}
