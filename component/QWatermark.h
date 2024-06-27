#ifndef QWATERMARK_H
#define QWATERMARK_H

#include <QQuickItem>
#include <QQuickPaintedItem>
#include <QPainter>
#include "stdafx.h"

/**
 * @brief The QWatermark class
 */
class QWatermark : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY_AUTO(QString,text)
    Q_PROPERTY_AUTO(QPoint,gap)
    Q_PROPERTY_AUTO(QPoint,offset);
    Q_PROPERTY_AUTO(QColor,textColor);
    Q_PROPERTY_AUTO(int,rotate);
    Q_PROPERTY_AUTO(int,textSize);
    QML_NAMED_ELEMENT(QWatermark)
public:
    explicit QWatermark(QQuickItem *parent = nullptr);
    void paint(QPainter* painter) override;
};

#endif // QWATERMARK_H
