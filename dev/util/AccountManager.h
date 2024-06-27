#ifndef ACCOUNTMANAGER_H
#define ACCOUNTMANAGER_H

#include <QObject>
#include <QString>
#include "dev/singleton.h"

class AccountManager : public QObject, public Singleton<AccountManager>
{
    Q_OBJECT
    Q_PROPERTY(bool isLoggedIn READ isLoggedIn NOTIFY loggedInChanged)
    Q_PROPERTY(QString userEmail READ userEmail NOTIFY userEmailChanged)
    Q_PROPERTY(bool saveAccountLocally READ saveAccountLocally WRITE setSaveAccountLocally NOTIFY saveAccountLocallyChanged)
    Q_PROPERTY(int accountId READ accountId NOTIFY accountIdChanged)

public:
    bool isLoggedIn() const;
    QString userEmail() const;
    bool saveAccountLocally() const;
    int accountId() const;

public slots:
    bool loginAccount(const QString &email, const QString &password);
    void logoutAccount();
    void setSaveAccountLocally(bool save);

signals:
    void loggedInChanged();
    void userEmailChanged();
    void saveAccountLocallyChanged();
    void accountIdChanged();

private:
    friend class Singleton<AccountManager>;
    explicit AccountManager(QObject *parent = nullptr);
    ~AccountManager() = default;
    AccountManager(const AccountManager&) = delete;
    AccountManager& operator=(const AccountManager&) = delete;

    void initialize();

    bool m_isLoggedIn;
    QString m_userEmail;
    bool m_saveAccountLocally;
    int m_accountId;
};

#endif // ACCOUNTMANAGER_H
