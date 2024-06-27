#ifndef EXIFEXTRACTOR_H
#define EXIFEXTRACTOR_H

#include <QObject>
#include <QString>

class ExifExtractor : public QObject {
    Q_OBJECT
public:
    explicit ExifExtractor(QObject *parent = nullptr);

    Q_INVOKABLE QString extractExifLocation(const QString& imagePath);
};

#endif // EXIFEXTRACTOR_H
