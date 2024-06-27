#ifndef PROFILEVALIDATOR_H
#define PROFILEVALIDATOR_H

#include <QObject>
#include <QString>
#include <QRegularExpression>
#include <QDate>
#include <QVector>

class ProfileValidator : public QObject
{
    Q_OBJECT

public:
    explicit ProfileValidator(QObject *parent = nullptr);
    ~ProfileValidator() = default;

    Q_INVOKABLE QString validateName(const QString &name, bool isFirstName) const;
    Q_INVOKABLE QString validateCNP(const QString &cnp) const;
    Q_INVOKABLE QString validateEmail(const QString &email) const;
    Q_INVOKABLE QString validatePhoneNumber(const QString &phoneNumber) const;
    Q_INVOKABLE QString validateNotEmpty(const QString &field) const;
    QString getErrorMessage() const;

private:
    mutable QString m_errorMessage;

    bool algorithmCNP(const QString &cnp) const;
};

#endif // PROFILEVALIDATOR_H
