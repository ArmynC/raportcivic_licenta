#include "QWatermark.h"

QWatermark::QWatermark(QQuickItem* parent) : QQuickPaintedItem(parent){
    gap(QPoint(100,100));
    offset(QPoint(_gap.x()/2,_gap.y()/2));
    rotate(22);
    setZ(9999);
    textColor(QColor(222,222,222,222));
    textSize(16);
    connect(this,&QWatermark::textColorChanged,this,[=]{update();});
    connect(this,&QWatermark::gapChanged,this,[=]{update();});
    connect(this,&QWatermark::offsetChanged,this,[=]{update();});
    connect(this,&QWatermark::textChanged,this,[=]{update();});
    connect(this,&QWatermark::rotateChanged,this,[=]{update();});
    connect(this,&QWatermark::textSizeChanged,this,[=]{update();});
}

void QWatermark::paint(QPainter* painter){
    QFont font;
    font.setPixelSize(_textSize);
    painter->setFont(font);
    painter->setPen(_textColor);
    QFontMetricsF fontMetrics(font);
    qreal fontWidth = fontMetrics.horizontalAdvance(_text);
    qreal fontHeight = fontMetrics.height();
    int stepX =  fontWidth + _gap.x();
    int stepY =  fontHeight + _gap.y();
    int rowCount = width() / stepX+1;
    int colCount = height() / stepY+1;
    for (int r = 0; r < rowCount; r++)
    {
        for (int c = 0; c < colCount; c++)
        {
            qreal centerX = stepX * r + _offset.x() + fontWidth / 2.0;
            qreal centerY = stepY * c + _offset.y() + fontHeight / 2.0;
            painter->save();
            painter->translate(centerX, centerY);
            painter->rotate(_rotate);
            painter->drawText(QRectF(-fontWidth / 2.0, -fontHeight / 2.0, fontWidth, fontHeight), _text);
            painter->restore();
        }
    }
}
