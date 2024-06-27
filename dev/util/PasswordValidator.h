#ifndef PASSWORDVALIDATOR_H
#define PASSWORDVALIDATOR_H

#include <QObject>
#include <QRegularExpression>

class PasswordValidator : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int minLength READ minLength WRITE setMinLength NOTIFY minLengthChanged)

public:
    explicit PasswordValidator(QObject *parent = nullptr);

    Q_INVOKABLE bool isPasswordStrong(const QString &password) const;
    Q_INVOKABLE bool isEmailValid(const QString &email) const;
    Q_INVOKABLE QString getErrorMessage() const;

    int minLength() const;
    void setMinLength(int length);

signals:
    void minLengthChanged(int length);

private:
    int m_minLength = 10; // minimal length for password
    mutable QString m_errorMessage;

    bool containsLowerCase(const QString &password) const;
    bool containsUpperCase(const QString &password) const;
    bool containsDigit(const QString &password) const;
    bool containsSpecialChar(const QString &password) const;
};

#endif // PASSWORDVALIDATOR_H
