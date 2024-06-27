#include "UrlOpener.h"
#include <QDesktopServices>
#include <QUrl>

bool UrlOpener::openUrl(const QString &url)
{
    return QDesktopServices::openUrl(QUrl(url));
}
