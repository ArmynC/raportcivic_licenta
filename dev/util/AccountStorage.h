#ifndef ACCOUNTSTORAGE_H
#define ACCOUNTSTORAGE_H

#include <QString>
#include <QStandardPaths>
#include <QFile>
#include <QDataStream>
#include <sodium.h>

class AccountStorage {
public:
    static bool saveAccount(const QString &email, const QString &password);
    static bool loadAccount(QString &email, QString &password);
    static void clearAccountData();

private:
    static QString getAccountDataFilePath();
    static QByteArray encryptData(const QByteArray &data, const QByteArray &key);
    static QByteArray decryptData(const QByteArray &encryptedData, const QByteArray &key);
};

#endif // ACCOUNTSTORAGE_H
