#include "ProfileValidator.h"

ProfileValidator::ProfileValidator(QObject *parent)
    : QObject(parent)
{
}

QString ProfileValidator::validateNotEmpty(const QString &field) const
{
    QString trimmedField = field.trimmed();
    if (trimmedField.isEmpty()) {
        return QObject::tr("Campul nu poate fi gol.");
    }

    return QString();
}


QString ProfileValidator::validateName(const QString &name, bool isFirstName) const
{
    QString trimmedName = name.trimmed();
    if (trimmedName.isEmpty()) {
        return QObject::tr("Numele nu poate fi gol.");
    }

    if (isFirstName) {
        static const QRegularExpression firstNameRegex("^[a-zA-Z]+(\\s[a-zA-Z]+)*$");
        if (!firstNameRegex.match(trimmedName).hasMatch()) {
            return QObject::tr("Prenumele poate continue numai litere si spatii.");
        }
    } else {
        static const QRegularExpression lastNameRegex("^[a-zA-Z]+$");
        if (!lastNameRegex.match(trimmedName).hasMatch()) {
            return QObject::tr("Numele de familie poate contine doar litere.");
        }
    }

    return QString(); // passed validation
}

QString ProfileValidator::validateCNP(const QString &cnp) const
{
    QString trimmedCnp = cnp.trimmed();
    if (trimmedCnp.isEmpty()) {
        return QObject::tr("CNP-ul nu poate fi gol.");
    }

    if (!algorithmCNP(trimmedCnp)) {
        return QObject::tr("CNP invalid.");
    }

    return QString();
}

QString ProfileValidator::validateEmail(const QString &email) const
{
    QString trimmedEmail = email.trimmed();
    static const QRegularExpression emailRegex("\\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}\\b", QRegularExpression::CaseInsensitiveOption);
    if (!emailRegex.match(trimmedEmail).hasMatch()) {
        return QObject::tr("Adresa email invalida.");
    }

    return QString();
}

QString ProfileValidator::validatePhoneNumber(const QString &phoneNumber) const
{
    QString trimmedPhoneNumber = phoneNumber.trimmed();
    if (trimmedPhoneNumber.isEmpty()) {
        return QString(); // allow empty phone number
    }

    static const QRegularExpression phoneRegex("^(\\+4|0)\\d{9}$");
    if (!phoneRegex.match(trimmedPhoneNumber).hasMatch()) {
        return QObject::tr("Format numar telefon invalid.");
    }

    return QString();
}

bool ProfileValidator::algorithmCNP(const QString &cnp) const
{
    /*  CNP layout: SS AA LL ZZ JJ NNN C */

    if (cnp.length() != 13 || !cnp.toULongLong()) {
        return false;
    }

    // S, AA, LL and AA component
    // gender-year, last 2 digits of the year, month, day
    QVector<int> digits(13);
    for (int i = 0; i < 13; ++i) {
        if (!cnp[i].isDigit()) {
            return false;
        }
        digits[i] = cnp[i].digitValue();
    }

    int year = digits[1] * 10 + digits[2];
    int month = digits[3] * 10 + digits[4];
    int day = digits[5] * 10 + digits[6];

    // determine century based on the first digit
    switch (digits[0]) {
    case 1: case 2:  // citizen born between year 1900->1999
        year += 1900;
        break;
    case 3: case 4:  // citizen born between year 1800->1899
        year += 1800;
        break;
    case 5: case 6:  // citizen born between year 2000->2099
        year += 2000;
        break;
    case 7: case 8:  // resident and temporary citizen
        break;

    default:
        return false;
    }

    QDate date(year, month, day);
    if (!date.isValid()) {
        return false;
    }

    // JJ component
    // county code (older format) or standard 70 (newer format)
    int countyCode = digits[7] * 10 + digits[8];
    if (countyCode != 70 && (countyCode < 1 || countyCode > 52)) {
        return false;
    }

    // NNN and and C component
    // sequential number per birth (a differentiator), checksum
    QVector<int> weights = {2, 7, 9, 1, 4, 6, 3, 5, 8, 2, 7, 9};
    int sum = 0;

    for (int i = 0; i < 12; ++i) {
        sum += digits[i] * weights[i];
    }

    int checksum = sum % 11;
    if (checksum == 10) {
        checksum = 1; // valid checksum
    }

    return checksum == digits[12];
}

QString ProfileValidator::getErrorMessage() const
{
    return m_errorMessage;
}
