#include "AccountManager.h"
#include "DbManager.h"
#include "AccountStorage.h"
#include <QDebug>

AccountManager::AccountManager(QObject *parent)
    : QObject(parent), m_isLoggedIn(false), m_saveAccountLocally(true), m_accountId(-1)
{
    QString email, password;
    if (AccountStorage::loadAccount(email, password)) { // existing account in storage
        m_isLoggedIn = true;
        m_userEmail = email;
        DbManager dbManager;
        dbManager.updateLastLogin(email); // update last_login date
        m_accountId = dbManager.getAccountIdByEmail(email);
        initialize();
    }
}

void AccountManager::initialize()
{
    emit loggedInChanged();
    emit userEmailChanged();
    emit accountIdChanged();
}

bool AccountManager::isLoggedIn() const
{
    return m_isLoggedIn;
}

QString AccountManager::userEmail() const
{
    return m_userEmail;
}

bool AccountManager::saveAccountLocally() const
{
    return m_saveAccountLocally;
}

int AccountManager::accountId() const
{
    return m_accountId;
}

bool AccountManager::loginAccount(const QString &email, const QString &password)
{
    DbManager dbManager;
    QString userEmail = dbManager.verifyUser(email, password);

    if (!userEmail.isEmpty()) {
        m_isLoggedIn = true;
        m_userEmail = userEmail;
        m_accountId = dbManager.getAccountIdByEmail(email); // get accountId from database
        dbManager.updateLastLogin(email); // update last_login date
        emit loggedInChanged();
        emit userEmailChanged();
        emit accountIdChanged();

        if (m_saveAccountLocally) {
            AccountStorage::saveAccount(email, password);
        }

        qDebug() << "Logged in successfully. User email:" << userEmail << "Account ID:" << m_accountId;
        return true;
    }

    qDebug() << "Login failed.";
    return false;
}

void AccountManager::logoutAccount()
{
    m_isLoggedIn = false;
    m_userEmail.clear();
    m_accountId = -1; // reset
    emit loggedInChanged();
    emit userEmailChanged();
    emit accountIdChanged();

    if (m_saveAccountLocally) {
        AccountStorage::clearAccountData();
    }

    qDebug() << "Logged out.";
}

void AccountManager::setSaveAccountLocally(bool save)
{
    if (m_saveAccountLocally != save) {
        m_saveAccountLocally = save;
        emit saveAccountLocallyChanged();

        if (!m_saveAccountLocally) {
            AccountStorage::clearAccountData();
        }
    }
}
