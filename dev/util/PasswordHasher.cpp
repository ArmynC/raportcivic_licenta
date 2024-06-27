#include <QDebug>

#include "PasswordHasher.h"
#include <sodium.h>

PasswordHasher::PasswordHasher(QObject *parent) : QObject(parent) {
}

QString PasswordHasher::hashPassword(const QString &password) {

    /* hashing the password using argon2id
     * https://doc.libsodium.org/password_hashing
     * https://github.com/P-H-C/phc-winner-argon2
     */
    QByteArray hashedPassword(crypto_pwhash_STRBYTES, '\0');
    if (crypto_pwhash_str(hashedPassword.data(), password.toUtf8().data(), password.length(),
                          crypto_pwhash_OPSLIMIT_INTERACTIVE, crypto_pwhash_MEMLIMIT_INTERACTIVE) != 0) {
        qFatal("Out of memory");
    }

    // trim null characters while converting
    return QString::fromUtf8(hashedPassword.constData(), hashedPassword.indexOf('\0'));
}

bool PasswordHasher::verifyPassword(const QString &hashedPassword, const QString &password) {
    return crypto_pwhash_str_verify(hashedPassword.toUtf8().data(), password.toUtf8().data(), password.length()) == 0;
}
