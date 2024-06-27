#ifndef FILEREADER_H
#define FILEREADER_H

#include <QObject>

class FileReader : public QObject
{
    Q_OBJECT

public:
    FileReader(QObject *parent = nullptr);

    Q_INVOKABLE QString readFile(const QString &filePath) const;
};

#endif // FILEREADER_H
