#ifndef QRECTANGLE_H
#define QRECTANGLE_H

#include <QQuickItem>
#include <QQuickPaintedItem>
#include <QPainter>
#include "stdafx.h"

/**
 * @brief The QRectangle class
 */
class QRectangle : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY_AUTO(QColor,color)
    Q_PROPERTY_AUTO(QList<int>,radius)
    QML_NAMED_ELEMENT(QRectangle)
public:
    explicit QRectangle(QQuickItem *parent = nullptr);
    void paint(QPainter* painter) override;
};

#endif // QRECTANGLE_H
