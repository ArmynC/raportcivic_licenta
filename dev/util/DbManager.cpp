#include "DbManager.h"
#include "PasswordHasher.h"
#include <QSqlError>
#include <QSqlQuery>
#include <QVariant>

DbManager::DbManager(QObject *parent) : QObject(parent) {
}

bool DbManager::addUser(const QString &email, const QString &hashedPassword) {
    if (userExists(email)) {
        qDebug() << "User already exists!";
        return false;
    }

    QSqlQuery query;
    query.prepare("INSERT INTO Account (email, password_hash) VALUES (:email, :password_hash)");
    query.bindValue(":email", email);
    query.bindValue(":password_hash", hashedPassword);

    if (!query.exec()) {
        qDebug() << "Failed to add user: " << query.lastError().text();
        return false;
    }

    return true;
}

bool DbManager::userExists(const QString &email) {
    QSqlQuery query;
    query.prepare("SELECT email FROM Account WHERE email = :email");
    query.bindValue(":email", email);
    query.exec();

    return query.next();
}

QString DbManager::verifyUser(const QString &email, const QString &password)
{
    QSqlQuery query;
    query.prepare("SELECT email, password_hash FROM Account WHERE email = :email");
    query.bindValue(":email", email);

    if (!query.exec() || !query.next()) {
        qDebug() << "User not found!";
        return QString();
    }

    QString userEmail = query.value(0).toString();
    QString storedHash = query.value(1).toString();

    PasswordHasher hasher;
    if (hasher.verifyPassword(storedHash, password)) {
        return userEmail;
    } else {
        return QString();
    }
}

bool DbManager::updateLastLogin(const QString &email) {
    QSqlQuery query;
    query.prepare("UPDATE Account SET last_login = CURRENT_TIMESTAMP WHERE email = :email");
    query.bindValue(":email", email);

    if (!query.exec()) {
        qDebug() << "Failed to update last login:" << query.lastError().text();
        return false;
    }
    return true;
}

int DbManager::getAccountIdByEmail(const QString &email)
{
    // retrieve from database the accountId linked to the connected email
    QSqlQuery query;
    query.prepare("SELECT account_id FROM Account WHERE email = :email");
    query.bindValue(":email", email);

    if (query.exec() && query.next()) {
        return query.value(0).toInt();
    }
    return -1;
}

int DbManager::getCitizenIdByAccountId(int accountId)
{
    QSqlQuery query(db);
    query.prepare("SELECT citizen_id FROM CitizenData WHERE account_id = :accountId");
    query.bindValue(":accountId", accountId);

    if (query.exec() && query.next()) {
        return query.value(0).toInt();
    }

    return -1;
}

QVariantMap DbManager::createCitizenData(int accountId, const QString &lastName, const QString &firstName,
                                         const QString &personalNumericCode, const QString &username,
                                         const QString &contactEmail, const QString &phone)
{
    QVariantMap result;
    QSqlQuery query(db);
    query.prepare("INSERT INTO CitizenData (account_id, last_name, first_name, personal_numeric_code, username, contact_email, phone, last_modification) "
                  "VALUES (:accountId, :lastName, :firstName, :personalNumericCode, :username, :contactEmail, :phone, CURRENT_TIMESTAMP)");
    query.bindValue(":accountId", accountId);
    query.bindValue(":lastName", lastName);
    query.bindValue(":firstName", firstName);
    query.bindValue(":personalNumericCode", personalNumericCode);
    query.bindValue(":username", username);
    query.bindValue(":contactEmail", contactEmail);
    query.bindValue(":phone", phone);

    if (!query.exec()) {
        result["success"] = false;
        result["error"] = query.lastError().text();
        return result;
    }

    result["success"] = true;
    result["data"] = QVariantMap{{"accountId", accountId}, {"lastName", lastName}, {"firstName", firstName}};
    return result;
}

QVariantMap DbManager::updateCitizenData(int citizenId, const QString &lastName, const QString &firstName,
                                         const QString &personalNumericCode, const QString &username,
                                         const QString &contactEmail, const QString &phone)
{
    QVariantMap result;
    QSqlQuery query(db);
    query.prepare("UPDATE CitizenData SET last_name = :lastName, first_name = :firstName, "
                  "personal_numeric_code = :personalNumericCode, username = :username, "
                  "contact_email = :contactEmail, phone = :phone, last_modification = CURRENT_TIMESTAMP "
                  "WHERE citizen_id = :citizenId");
    query.bindValue(":citizenId", citizenId);
    query.bindValue(":lastName", lastName);
    query.bindValue(":firstName", firstName);
    query.bindValue(":personalNumericCode", personalNumericCode);
    query.bindValue(":username", username);
    query.bindValue(":contactEmail", contactEmail);
    query.bindValue(":phone", phone);

    if (!query.exec()) {
        result["success"] = false;
        result["error"] = query.lastError().text();
        return result;
    }

    result["success"] = true;
    result["data"] = QVariantMap{{"citizenId", citizenId}, {"lastName", lastName}, {"firstName", firstName}};
    return result;
}

QVariantMap DbManager::createAddress(int citizenId, const QString &county, const QString &city,
                                     const QString &street, const QString &building,
                                     const QString &entrance, const QString &apartment)
{
    QVariantMap result;
    QSqlQuery query(db);
    query.prepare("INSERT INTO Address (citizen_id, county, city, street, building, entrance, apartment, last_modification) "
                  "VALUES (:citizenId, :county, :city, :street, :building, :entrance, :apartment, CURRENT_TIMESTAMP)");
    query.bindValue(":citizenId", citizenId);
    query.bindValue(":county", county);
    query.bindValue(":city", city);
    query.bindValue(":street", street);
    query.bindValue(":building", building);
    query.bindValue(":entrance", entrance);
    query.bindValue(":apartment", apartment);

    if (!query.exec()) {
        result["success"] = false;
        result["error"] = query.lastError().text();
        return result;
    }

    result["success"] = true;
    result["data"] = QVariantMap{{"citizenId", citizenId}, {"county", county}, {"city", city}};
    return result;
}

QVariantMap DbManager::updateAddress(int addressId, const QString &county, const QString &city,
                                     const QString &street, const QString &building,
                                     const QString &entrance, const QString &apartment)
{
    QVariantMap result;
    QSqlQuery query(db);
    query.prepare("UPDATE Address SET county = :county, city = :city, street = :street, "
                  "building = :building, entrance = :entrance, apartment = :apartment, "
                  "last_modification = CURRENT_TIMESTAMP WHERE address_id = :addressId");
    query.bindValue(":addressId", addressId);
    query.bindValue(":county", county);
    query.bindValue(":city", city);
    query.bindValue(":street", street);
    query.bindValue(":building", building);
    query.bindValue(":entrance", entrance);
    query.bindValue(":apartment", apartment);

    if (!query.exec()) {
        result["success"] = false;
        result["error"] = query.lastError().text();
        return result;
    }

    result["success"] = true;
    result["data"] = QVariantMap{{"addressId", addressId}, {"county", county}, {"city", city}};
    return result;
}

QVariantMap DbManager::getCitizenDataByAccountId(int accountId)
{
    QSqlQuery query;
    query.prepare("SELECT * FROM CitizenData WHERE account_id = :accountId");
    query.bindValue(":accountId", accountId);

    if (query.exec()) {
        if (query.next()) {
            QVariantMap data;
            data["citizen_id"] = query.value("citizen_id");
            data["last_name"] = query.value("last_name");
            data["first_name"] = query.value("first_name");
            data["personal_numeric_code"] = query.value("personal_numeric_code");
            data["username"] = query.value("username");
            data["contact_email"] = query.value("contact_email");
            data["phone"] = query.value("phone");
            return QVariantMap{{"success", true}, {"data", data}};
        } else {
            return QVariantMap{{"success", false}, {"error", "No citizen data found for the given account ID"}};
        }
    } else {
        return QVariantMap{{"success", false}, {"error", query.lastError().text()}};
    }
}

QVariantMap DbManager::getAddressByAccountId(int accountId)
{
    QSqlQuery query;
    query.prepare("SELECT a.* FROM Address a JOIN CitizenData c ON a.citizen_id = c.citizen_id WHERE c.account_id = :accountId");
    query.bindValue(":accountId", accountId);

    if (query.exec()) {
        if (query.next()) {
            QVariantMap data;
            data["address_id"] = query.value("address_id");
            data["county"] = query.value("county");
            data["city"] = query.value("city");
            data["street"] = query.value("street");
            data["building"] = query.value("building");
            data["entrance"] = query.value("entrance");
            data["apartment"] = query.value("apartment");
            return QVariantMap{{"success", true}, {"data", data}};
        } else {
            return QVariantMap{{"success", false}, {"error", "No address data found for the given account ID"}};
        }
    } else {
        return QVariantMap{{"success", false}, {"error", query.lastError().text()}};
    }
}
