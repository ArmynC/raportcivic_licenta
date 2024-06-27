#include "FileReader.h"
#include <QFile>
#include <QTextStream>
#include <QUrl>
#include <QDebug>

FileReader::FileReader(QObject *parent)
    : QObject(parent)
{
}

QString FileReader::readFile(const QString &filePath) const
{
    QUrl url(filePath);

    // check if local file
    if (url.isLocalFile()) {
        QFile file(url.toLocalFile());

        if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
            qWarning("Failed to open file for reading: %s", qPrintable(file.errorString()));
            return QString();
        }

        // get content
        QTextStream stream(&file);
        QString content = stream.readAll();
        file.close();
        return content;
    }
    else if (url.scheme() == "qrc") {   // check if "qrc" resource file schema
        QFile file(":/" + url.path());

        if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
            qWarning("Failed to open resource file for reading: %s", qPrintable(file.errorString()));
            return QString();
        }

        // get content
        QTextStream stream(&file);
        QString content = stream.readAll();
        file.close();
        return content;
    }
    else {
        qWarning("Unsupported file path for file reading: %s", qPrintable(filePath));
        return QString();
    }
}
