#include "PasswordValidator.h"

PasswordValidator::PasswordValidator(QObject *parent)
    : QObject(parent)
{
}

bool PasswordValidator::isPasswordStrong(const QString &password) const
{
    if (password.length() < m_minLength) {
        m_errorMessage = QObject::tr("Parola necesita cel putin %1 caractere.").arg(m_minLength);
        return false;
    }

    if (!containsLowerCase(password)) {
        m_errorMessage = QObject::tr("Parola necesita cel putin o litera mica.");
        return false;
    }

    if (!containsUpperCase(password)) {
        m_errorMessage = QObject::tr("Parola necesita cel putin o litera mare.");
        return false;
    }

    if (!containsDigit(password)) {
        m_errorMessage = QObject::tr("Parola necesita cel putin o cifra.");
        return false;
    }

    if (!containsSpecialChar(password)) {
        m_errorMessage = QObject::tr("Parola necesita cel putin un caracter special.");
        return false;
    }

    m_errorMessage.clear();
    return true;
}

bool PasswordValidator::isEmailValid(const QString &email) const
{
    // email@domain.tld
    static const QRegularExpression regex("\\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}\\b", QRegularExpression::CaseInsensitiveOption);
    if (!regex.match(email).hasMatch()) {
        m_errorMessage = QObject::tr("Adresa de email nu este valida.");
        return false;
    }

    m_errorMessage.clear();
    return true;
}

QString PasswordValidator::getErrorMessage() const
{
    return m_errorMessage;
}

int PasswordValidator::minLength() const
{
    return m_minLength;
}

void PasswordValidator::setMinLength(int length)
{
    if (m_minLength != length) {
        m_minLength = length;
        emit minLengthChanged(length);
    }
}

bool PasswordValidator::containsLowerCase(const QString &password) const
{
    static const QRegularExpression regex("[a-z]");
    return password.contains(regex);
}

bool PasswordValidator::containsUpperCase(const QString &password) const
{
    static const QRegularExpression regex("[A-Z]");
    return password.contains(regex);
}

bool PasswordValidator::containsDigit(const QString &password) const
{
    static const QRegularExpression regex("\\d");
    return password.contains(regex);
}

bool PasswordValidator::containsSpecialChar(const QString &password) const
{
    static const QRegularExpression regex("[^a-zA-Z\\d]");
    return password.contains(regex);
}
