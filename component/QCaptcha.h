#ifndef QCAPTCHA_H
#define QCAPTCHA_H

#include <QQuickItem>
#include <QQuickPaintedItem>
#include <QPainter>
#include "stdafx.h"

class QCaptcha : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY_AUTO(QFont,font);
    Q_PROPERTY_AUTO(bool,ignoreCase);
    QML_NAMED_ELEMENT(QCaptcha)
private:
    int _generaNumber(int number);
public:
    explicit QCaptcha(QQuickItem *parent = nullptr);
    void paint(QPainter* painter) override;
    Q_INVOKABLE void refresh();
    Q_INVOKABLE bool verify(const QString& code);
private:
    QString _code;
};

#endif // QCAPTCHA_H
