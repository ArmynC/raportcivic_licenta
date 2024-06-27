#ifndef QTHEME_H
#define QTHEME_H

#include <QObject>
#include <QtQml/qqml.h>
#include <QJsonArray>
#include <QJsonObject>
#include <QColor>
#include "QAccentColor.h"
#include "stdafx.h"
#include "singleton.h"

/**
 * @brief The QTheme class
 */
class QTheme : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool dark READ dark NOTIFY darkChanged)
    Q_PROPERTY_AUTO(QAccentColor*,accentColor);
    Q_PROPERTY_AUTO(QColor,primaryColor);
    Q_PROPERTY_AUTO(QColor,backgroundColor);
    Q_PROPERTY_AUTO(QColor,dividerColor);
    Q_PROPERTY_AUTO(QColor,windowBackgroundColor);
    Q_PROPERTY_AUTO(QColor,windowActiveBackgroundColor);
    Q_PROPERTY_AUTO(QColor,fontPrimaryColor);
    Q_PROPERTY_AUTO(QColor,fontSecondaryColor);
    Q_PROPERTY_AUTO(QColor,fontTertiaryColor);
    Q_PROPERTY_AUTO(QColor,itemNormalColor);
    Q_PROPERTY_AUTO(QColor,itemHoverColor);
    Q_PROPERTY_AUTO(QColor,itemPressColor);
    Q_PROPERTY_AUTO(QColor,itemCheckColor);
    Q_PROPERTY_AUTO(int,darkMode);
    Q_PROPERTY_AUTO(bool,nativeText);
    Q_PROPERTY_AUTO(bool,animationEnabled);
    QML_NAMED_ELEMENT(QTheme)
    QML_SINGLETON
private:
    explicit QTheme(QObject *parent = nullptr);
    bool eventFilter(QObject *obj, QEvent *event);
    bool systemDark();
    void refreshColors();
public:
    SINGLETON(QTheme)
    Q_INVOKABLE QJsonArray awesomeList(const QString& keyword = "");
    Q_SIGNAL void darkChanged();
    static QTheme *create(QQmlEngine *qmlEngine, QJSEngine *jsEngine){return getInstance();}
    bool dark();
private:
    bool _systemDark;
};

#endif // QTHEME_H
