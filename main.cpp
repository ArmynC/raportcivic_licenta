#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDir>
#include <QQuickWindow>
#include <QSqlDatabase>
#include <QSqlError>
#include <QNetworkProxy>
#include <QSslConfiguration>
#include <QProcess>
#include <QtQml/qqmlextensionplugin.h>
#include <QLoggingCategory>

#include "build.h"
#include "dev/AppVersion.h"
#include "dev/util/Log.h"
#include "dev/units/CircularReveal.h"
#include "dev/util/AccountManager.h"
#include "dev/util/DbManager.h"
#include "dev/util/ExifExtractor.h"
#include "dev/util/FileReader.h"
#include "dev/util/JsonParser.h"
#include "dev/util/PasswordHasher.h"
#include "dev/util/PasswordValidator.h"
#include "dev/util/ProfileValidator.h"
#include "dev/util/QmlBridge.h"
#include "dev/util/ReportBridge.h"
#include "dev/util/ReportJsonManager.h"
#include "dev/util/SettingsHelper.h"
#include "dev/util/TranslateHelper.h"
#include "dev/util/UrlOpener.h"
#include "dev/util/NetworkCore.h"

#include <sodium.h>

#ifdef WIN32
#include "dev/AppDmp.h"
#endif

int main(int argc, char *argv[])
{
#ifdef WIN32
    ::SetUnhandledExceptionFilter(FaultHandler);
    qputenv("QT_QPA_PLATFORM", "windows:darkmode=2");
#endif

    qputenv("QT_QUICK_CONTROLS_STYLE", "Basic");

    QGuiApplication::setOrganizationName("ArminC");
    QGuiApplication::setOrganizationDomain("https://github.com/ArmynC");
    QGuiApplication::setApplicationName("RaportCivic");
    QGuiApplication::setApplicationVersion(APP_BUILD);
    QGuiApplication::setWindowIcon(QIcon(":/assets/icons/logo.png"));
    QGuiApplication::setQuitOnLastWindowClosed(false);

    SettingsHelper::getInstance().init(argv);
    Log::setup(argv, "RaportCivic_Core");
    QQuickWindow::setGraphicsApi(QSGRendererInterface::OpenGL);

    QGuiApplication app(argc, argv);

    // set QT_PLUGIN_PATH for standalone deployment
    QString pluginPath = QCoreApplication::applicationDirPath() + "/plugins";
    qputenv("QT_PLUGIN_PATH", QDir::toNativeSeparators(pluginPath).toUtf8());

    if (sodium_init() < 0) {
        qDebug() << "Failed to initialize libsodium!";
        return -1;
    } else {
        qDebug() << "Successfully initialized libsodium!";
    }

    // https://doc.qt.io/qt-6/qsqldatabase.html
    QSqlDatabase db = QSqlDatabase::addDatabase("QPSQL");
    db.setHostName("");
    db.setPort(19099);
    db.setDatabaseName("db");
    db.setUserName("admin");
    db.setPassword("");
    // db.setConnectOptions("requiressl=1;sslmode=require;sslrootcert=ca.pem");

    bool dbConnected = false;
    QString dbErrorMessage;
    if (!db.open()) {
        dbErrorMessage = "Failed to connect to the database: " + db.lastError().text();
        qWarning() << dbErrorMessage;
        qWarning() << "The application will continue without database connectivity.";
    } else {
        qDebug() << "Connected successfully to the database!";
        dbConnected = true;
    }

    // https://doc.qt.io/qt-6/qqmlengine.html#qmlRegisterType
    // @uri module
    const char *uri = "module";
    qmlRegisterType<CircularReveal>(uri, 1, 0, "CircularReveal");
    qmlRegisterType<FileReader>(uri, 1, 0, "FileReader");
    qmlRegisterType<NetworkCallable>(uri, 1, 0, "NetworkCallable");
    qmlRegisterType<NetworkParams>(uri, 1, 0, "NetworkParams");
    qmlRegisterType<DbManager>(uri, 1, 0, "DbManager");
    qmlRegisterType<PasswordHasher>(uri, 1, 0, "PasswordHasher");
    qmlRegisterType<PasswordValidator>(uri, 1, 0, "PasswordValidator");
    qmlRegisterType<ProfileValidator>(uri, 1, 0, "ProfileValidator");
    qmlRegisterType<ExifExtractor>(uri, 1, 0, "ExifExtractor");
    qmlRegisterType<ReportJsonManager>(uri, 1, 0, "ReportJsonManager");

    // context properties classes with singleton nature
    QQmlApplicationEngine engine;
    TranslateHelper::getInstance().init(&engine);
    engine.rootContext()->setContextProperty("applicationEngine", &engine);
    engine.rootContext()->setContextProperty("AppVersion", &AppVersion::getInstance());
    engine.rootContext()->setContextProperty("SettingsHelper", &SettingsHelper::getInstance());
    engine.rootContext()->setContextProperty("TranslateHelper", &TranslateHelper::getInstance());
    engine.rootContext()->setContextProperty("Network", &Network::getInstance());
    engine.rootContext()->setContextProperty("AccountManager", &AccountManager::getInstance());
    engine.rootContext()->setContextProperty("QmlBridge", &QmlBridge::getInstance());
    engine.rootContext()->setContextProperty("JsonParser", &JsonParser::getInstance());
    engine.rootContext()->setContextProperty("ReportBridge", &ReportBridge::getInstance());
    engine.rootContext()->setContextProperty("UrlOpener", &UrlOpener::getInstance());

    // indicate database connection status
    engine.rootContext()->setContextProperty("dbConnected", dbConnected);
    engine.rootContext()->setContextProperty("dbErrorMessage", dbErrorMessage);

    const QUrl url(QStringLiteral("qrc:/qt/qml/src/qml/App.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);

    engine.load(url);

    const int exec = QGuiApplication::exec();
    if (exec == 931) {
        QProcess::startDetached(qApp->applicationFilePath(), qApp->arguments());
    }

    return exec;
}
