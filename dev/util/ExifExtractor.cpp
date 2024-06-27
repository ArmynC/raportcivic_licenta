#include "ExifExtractor.h"
#include <QFile>
#include <QDebug>
#include "TinyEXIF.h"

ExifExtractor::ExifExtractor(QObject *parent)
    : QObject(parent) {}

QString ExifExtractor::extractExifLocation(const QString& imagePath) {
    QFile file(imagePath);
    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "Failed to open file:" << imagePath;
        return QString();
    }

    QByteArray data = file.readAll();
    file.close();

    TinyEXIF::EXIFInfo exifInfo;
    qDebug() << "File read successfully, size:" << data.size();

    int parseResult = exifInfo.parseFrom(reinterpret_cast<const unsigned char*>(data.data()), data.size());
    qDebug() << "EXIF parse result:" << parseResult;

    if (parseResult == 0) {
        if (exifInfo.GeoLocation.hasLatLon()) { // verify if lat and long exists
            double latitude = exifInfo.GeoLocation.Latitude;
            double longitude = exifInfo.GeoLocation.Longitude;
            qDebug() << "Latitude:" << latitude;
            qDebug() << "Longitude:" << longitude;
            return QString("Latitude: %1, Longitude: %2").arg(latitude).arg(longitude);
        } else {
            qWarning() << "No GPS data found in the image" << imagePath;
        }
    } else {
        qWarning() << "Failed to load EXIF data, error code:" << parseResult;
    }

    return QString();
}
