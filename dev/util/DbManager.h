#ifndef DBMANAGER_H
#define DBMANAGER_H

#include <QObject>
#include <QSqlDatabase>

class DbManager : public QObject
{
    Q_OBJECT

public:
    explicit DbManager(QObject *parent = nullptr);

    Q_INVOKABLE bool addUser(const QString &email, const QString &hashedPassword);
    bool userExists(const QString &email);
    QString verifyUser(const QString &email, const QString &password);

    bool updateLastLogin(const QString &email);

    Q_INVOKABLE int getAccountIdByEmail(const QString &email);

    Q_INVOKABLE QVariantMap createCitizenData(int accountId, const QString &lastName, const QString &firstName,
                                              const QString &personalNumericCode, const QString &username,
                                              const QString &contactEmail, const QString &phone);
    Q_INVOKABLE QVariantMap updateCitizenData(int citizenId, const QString &lastName, const QString &firstName,
                                              const QString &personalNumericCode, const QString &username,
                                              const QString &contactEmail, const QString &phone);

    Q_INVOKABLE QVariantMap createAddress(int citizenId, const QString &county, const QString &city,
                                          const QString &street, const QString &building,
                                          const QString &entrance, const QString &apartment);
    Q_INVOKABLE QVariantMap updateAddress(int addressId, const QString &county, const QString &city,
                                          const QString &street, const QString &building,
                                          const QString &entrance, const QString &apartment);

    Q_INVOKABLE QVariantMap getCitizenDataByAccountId(int accountId);
    Q_INVOKABLE QVariantMap getAddressByAccountId(int accountId);


private:
    QSqlDatabase db;
    int getCitizenIdByAccountId(int accountId);
};

#endif // DBMANAGER_H
