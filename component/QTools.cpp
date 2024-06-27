#include "QTools.h"

#include <QGuiApplication>
#include <QClipboard>
#include <QUuid>
#include <QCursor>
#include <QScreen>
#include <QColor>
#include <QFileInfo>
#include <QProcess>
#include <QDir>
#include <QOpenGLContext>
#include <QCryptographicHash>
#include <QTextDocument>
#include <QQuickWindow>
#include <QDateTime>
#include <QSettings>

QTools::QTools(QObject *parent):QObject{parent}{

}

void QTools::clipText(const QString& text){
    QGuiApplication::clipboard()->setText(text);
}

QString QTools::uuid(){
    return QUuid::createUuid().toString().remove('-').remove('{').remove('}');
}

QString QTools::readFile(const QString &fileName){
    QString content;
    QFile file(fileName);
    if (file.open(QIODevice::ReadOnly)) {
        QTextStream stream(&file);
        content = stream.readAll();
    }
    return content;
}

bool QTools::isMacos(){
#if defined(Q_OS_MACOS)
    return true;
#else
    return false;
#endif
}

bool QTools::isLinux(){
#if defined(Q_OS_LINUX)
    return true;
#else
    return false;
#endif
}

bool QTools::isWin(){
#if defined(Q_OS_WIN)
    return true;
#else
    return false;
#endif
}

int QTools::qtMajor(){
    const QString qtVersion = QString::fromLatin1(qVersion());
    const QStringList versionParts = qtVersion.split('.');
    return versionParts[0].toInt();
}

int QTools::qtMinor(){
    const QString qtVersion = QString::fromLatin1(qVersion());
    const QStringList versionParts = qtVersion.split('.');
    return versionParts[1].toInt();
}

void QTools::setQuitOnLastWindowClosed(bool val){
    qApp->setQuitOnLastWindowClosed(val);
}

void QTools::setOverrideCursor(Qt::CursorShape shape){
    qApp->setOverrideCursor(QCursor(shape));
}

void QTools::restoreOverrideCursor(){
    qApp->restoreOverrideCursor();
}

void QTools::deleteLater(QObject *p){
    if(p){
        p->deleteLater();
        p = nullptr;
    }
}

QString QTools::toLocalPath(const QUrl& url){
    return url.toLocalFile();
}

QString QTools::getFileNameByUrl(const QUrl& url){
    return QFileInfo(url.toLocalFile()).fileName();
}

QString QTools::html2PlantText(const QString& html){
    QTextDocument textDocument;
    textDocument.setHtml(html);
    return textDocument.toPlainText();
}

QRect QTools::getVirtualGeometry(){
    return qApp->primaryScreen()->virtualGeometry();
}

QString QTools::getApplicationDirPath(){
    return qApp->applicationDirPath();
}

QUrl QTools::getUrlByFilePath(const QString& path){
    return QUrl::fromLocalFile(path);
}

QColor QTools::withOpacity(const QColor& color,qreal opacity){
    int alpha = qRound(opacity * 255) & 0xff;
    return QColor::fromRgba((alpha << 24) | (color.rgba() & 0xffffff));
}

QString QTools::md5(QString text){
    return QCryptographicHash::hash(text.toUtf8(), QCryptographicHash::Md5).toHex();
}

QString QTools::toBase64(QString text){
    return text.toUtf8().toBase64();
}

QString QTools::fromBase64(QString text){
    return QByteArray::fromBase64(text.toUtf8());
}

bool QTools::removeDir(QString dirPath){
    QDir qDir(dirPath);
    return qDir.removeRecursively();
}

bool QTools::removeFile(QString filePath){
    QFile file(filePath);
    return file.remove();
}

QString QTools::sha256(QString text){
    return QCryptographicHash::hash(text.toUtf8(), QCryptographicHash::Sha256).toHex();
}

void QTools::showFileInFolder(QString path){
#if defined(Q_OS_WIN)
    QProcess::startDetached("explorer.exe", {"/select,", QDir::toNativeSeparators(path)});
#endif
#if defined(Q_OS_LINUX)
    QFileInfo fileInfo(path);
    auto process = "xdg-open";
    auto arguments = { fileInfo.absoluteDir().absolutePath() };
    QProcess::startDetached(process, arguments);
#endif
#if defined(Q_OS_MACOS)
    QProcess::execute("/usr/bin/osascript", {"-e", "tell application \"Finder\" to reveal POSIX file \"" + path + "\""});
    QProcess::execute("/usr/bin/osascript", {"-e", "tell application \"Finder\" to activate"});
#endif
}

bool QTools::isSoftware(){
    return QQuickWindow::sceneGraphBackend() == "software";
}

QPoint QTools::cursorPos(){
    return QCursor::pos();
}

qint64 QTools::currentTimestamp(){
    return QDateTime::currentMSecsSinceEpoch();
}

QIcon QTools::windowIcon(){
    return QGuiApplication::windowIcon();
}

int QTools::cursorScreenIndex(){
    int screenIndex = 0;
    int screenCount = qApp->screens().count();
    if (screenCount > 1) {
        QPoint pos = QCursor::pos();
        for (int i = 0; i < screenCount; ++i) {
            if (qApp->screens().at(i)->geometry().contains(pos)) {
                screenIndex = i;
                break;
            }
        }
    }
    return screenIndex;
}

int QTools::windowBuildNumber(){
#if defined(Q_OS_WIN)
    QSettings regKey {QString::fromUtf8("HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion"), QSettings::NativeFormat};
    if (regKey.contains(QString::fromUtf8("CurrentBuildNumber"))) {
        auto buildNumber = regKey.value(QString::fromUtf8("CurrentBuildNumber")).toInt();
        return buildNumber;
    }
#endif
    return -1;
}

bool QTools::isWindows11OrGreater(){
    static QVariant var;
    if(var.isNull()){
#if defined(Q_OS_WIN)
        auto buildNumber = windowBuildNumber();
        if(buildNumber>=22000){
            var = QVariant::fromValue(true);
            return true;
        }
#endif
        var = QVariant::fromValue(false);
        return  false;
    }else{
        return var.toBool();
    }
}

bool QTools::isWindows10OrGreater(){
    static QVariant var;
    if(var.isNull()){
#if defined(Q_OS_WIN)
        auto buildNumber = windowBuildNumber();
        if(buildNumber>=10240){
            var = QVariant::fromValue(true);
            return true;
        }
#endif
        var = QVariant::fromValue(false);
        return  false;
    }else{
        return var.toBool();
    }
}

QRect QTools::desktopAvailableGeometry(QQuickWindow* window){
    return window->screen()->availableGeometry();
}
