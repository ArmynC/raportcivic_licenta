#include "AccountStorage.h"
#include <QDebug>

QString AccountStorage::getAccountDataFilePath() {
    return QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation) + "/account.dat";
}

QByteArray AccountStorage::encryptData(const QByteArray &data, const QByteArray &key) {

    // randon nonce
    QByteArray nonce(crypto_secretbox_NONCEBYTES, Qt::Uninitialized);
    randombytes_buf(nonce.data(), nonce.size());

    /* encrypt data using key and nonce
     * the authentication tag and the encrypted message are stored together
     * https://libsodium.gitbook.io/doc/secret-key_cryptography/secretbox
     */
    QByteArray encryptedData(data.size() + crypto_secretbox_MACBYTES, Qt::Uninitialized);
    crypto_secretbox_easy(reinterpret_cast<unsigned char*>(encryptedData.data()),
                          reinterpret_cast<const unsigned char*>(data.constData()),
                          data.size(),
                          reinterpret_cast<const unsigned char*>(nonce.constData()),
                          reinterpret_cast<const unsigned char*>(key.constData()));

    encryptedData.prepend(nonce); // add to header
    return encryptedData;
}

QByteArray AccountStorage::decryptData(const QByteArray &encryptedData, const QByteArray &key) {

    // get nonce and ciphertext from encrypted data
    QByteArray nonce = encryptedData.left(crypto_secretbox_NONCEBYTES);
    QByteArray ciphertext = encryptedData.mid(crypto_secretbox_NONCEBYTES);

    // decrypt with key and nonce
    QByteArray decryptedData(ciphertext.size() - crypto_secretbox_MACBYTES, Qt::Uninitialized);
    if (crypto_secretbox_open_easy(reinterpret_cast<unsigned char*>(decryptedData.data()),
                                   reinterpret_cast<const unsigned char*>(ciphertext.constData()),
                                   ciphertext.size(),
                                   reinterpret_cast<const unsigned char*>(nonce.constData()),
                                   reinterpret_cast<const unsigned char*>(key.constData())) != 0) {
        return QByteArray();
    }

    return decryptedData;
}

// add account data to file
bool AccountStorage::saveAccount(const QString &email, const QString &password) {
    QByteArray emailBytes = email.toUtf8();
    QByteArray passwordBytes = password.toUtf8();

    // random key
    QByteArray key(crypto_secretbox_KEYBYTES, Qt::Uninitialized);
    randombytes_buf(key.data(), key.size());

    // encrypt with the key
    QByteArray encryptedEmailBytes = encryptData(emailBytes, key);
    QByteArray encryptedPasswordBytes = encryptData(passwordBytes, key);

    QString filePath = getAccountDataFilePath();
    QFile file(filePath);
    if (!file.open(QIODevice::WriteOnly)) {
        qDebug() << "Failed to open user account data file for reading.";
        return false;
    }

    QDataStream out(&file);
    out << key << encryptedEmailBytes << encryptedPasswordBytes;

    file.close();
    qDebug() << "User account data saved successfully.";
    return true;
}

// load the data from the file
bool AccountStorage::loadAccount(QString &email, QString &password) {
    QString filePath = getAccountDataFilePath();
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly)) {
        return false;
    }

    // read the key and data
    QDataStream in(&file);
    QByteArray key, encryptedEmailBytes, encryptedPasswordBytes;
    in >> key >> encryptedEmailBytes >> encryptedPasswordBytes;

    // decrypt the data using the key
    QByteArray emailBytes = decryptData(encryptedEmailBytes, key);
    QByteArray passwordBytes = decryptData(encryptedPasswordBytes, key);

    if (emailBytes.isEmpty() || passwordBytes.isEmpty()) {
        file.close();
        qDebug() << "Failed to load user account data.";
        return false;
    }

    email = QString::fromUtf8(emailBytes);
    password = QString::fromUtf8(passwordBytes);

    file.close();
    qDebug() << "User account data loaded successfully.";
    return true;
}

// delete the account data file from storage
void AccountStorage::clearAccountData() {
    QString filePath = getAccountDataFilePath();
    QFile::remove(filePath);

    qDebug() << "User account data file deleted.";
}
