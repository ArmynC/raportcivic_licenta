#ifndef QQRCODEITEM_H
#define QQRCODEITEM_H

#include <QQuickItem>
#include <QQuickPaintedItem>
#include <QPainter>
#include "stdafx.h"

/**
 * @brief The QQrCodeItem class
 */
class QQrCodeItem : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY_AUTO(QString,text)
    Q_PROPERTY_AUTO(QColor,color)
    Q_PROPERTY_AUTO(QColor,bgColor)
    Q_PROPERTY_AUTO(int,size);
    QML_NAMED_ELEMENT(QQrCodeItem)
public:
    explicit QQrCodeItem(QQuickItem *parent = nullptr);
    void paint(QPainter* painter) override;
};

#endif // QQRCODEITEM_H
