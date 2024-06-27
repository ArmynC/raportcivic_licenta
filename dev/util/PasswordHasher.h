#ifndef PASSWORDHASHER_H
#define PASSWORDHASHER_H

#include <QObject>
#include <QString>

class PasswordHasher : public QObject {
    Q_OBJECT

public:
    explicit PasswordHasher(QObject *parent = nullptr);

    Q_INVOKABLE QString hashPassword(const QString &password);
    Q_INVOKABLE bool verifyPassword(const QString &hashedPassword, const QString &password);
};

#endif // PASSWORDHASHER_H
