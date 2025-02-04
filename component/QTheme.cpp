#include "QTheme.h"

#include <QGuiApplication>
#include <QPalette>
#include "Def.h"
#include "QColors.h"

QTheme::QTheme(QObject *parent):QObject{parent}{
    connect(this,&QTheme::darkModeChanged,this,[=]{
        Q_EMIT darkChanged();
    });
    connect(this,&QTheme::darkChanged,this,[=]{refreshColors();});
    connect(this,&QTheme::accentColorChanged,this,[=]{refreshColors();});
    accentColor(QColors::getInstance()->Blue());
    darkMode(QThemeType::DarkMode::Light);
    nativeText(false);
    animationEnabled(true);
    _systemDark = systemDark();
    qApp->installEventFilter(this);
}

void QTheme::refreshColors(){
    auto isDark = dark();
    primaryColor(isDark ? _accentColor->lighter() : _accentColor->dark());
    backgroundColor(isDark ? QColor(0,0,0,255) : QColor(255,255,255,255));
    dividerColor(isDark ? QColor(80,80,80,255) : QColor(210,210,210,255));
    windowBackgroundColor(isDark ? QColor(32,32,32,255) : QColor(237,237,237,255));
    windowActiveBackgroundColor(isDark ? QColor(26,26,26,255) : QColor(243,243,243,255));
    fontPrimaryColor(isDark ? QColor(248,248,248,255) : QColor(7,7,7,255));
    fontSecondaryColor(isDark ? QColor(222,222,222,255) : QColor(102,102,102,255));
    fontTertiaryColor(isDark ? QColor(200,200,200,255) : QColor(153,153,153,255));
    itemNormalColor(isDark ? QColor(255,255,255,0) : QColor(0,0,0,0));
    itemHoverColor(isDark ? QColor(255,255,255,255*0.06) : QColor(0,0,0,255*0.03));
    itemPressColor(isDark ? QColor(255,255,255,255*0.09) : QColor(0,0,0,255*0.06));
    itemCheckColor(isDark ? QColor(255,255,255,255*0.12) : QColor(0,0,0,255*0.09));
}

bool QTheme::eventFilter(QObject *obj, QEvent *event){
    Q_UNUSED(obj);
    if (event->type() == QEvent::ApplicationPaletteChange || event->type() == QEvent::ThemeChange)
    {
        _systemDark = systemDark();
        Q_EMIT darkChanged();
        event->accept();
        return true;
    }
    return false;
}

QJsonArray QTheme::awesomeList(const QString& keyword){
    QJsonArray arr;
    QMetaEnum enumType = Fluent_Awesome::staticMetaObject.enumerator(Fluent_Awesome::staticMetaObject.indexOfEnumerator("Fluent_AwesomeType"));
    for(int i=0; i < enumType.keyCount(); ++i){
        QString name = enumType.key(i);
        int icon = enumType.value(i);
        if(keyword.isEmpty() || name.contains(keyword)){
            QJsonObject obj;
            obj.insert("name",name);
            obj.insert("icon",icon);
            arr.append(obj);
        }
    }
    return arr;
}

bool QTheme::systemDark(){
    QPalette palette = qApp->palette();
    QColor color = palette.color(QPalette::Window).rgb();
    return !(color.red() * 0.2126 + color.green() * 0.7152 + color.blue() * 0.0722 > 255 / 2);
}

bool QTheme::dark(){
    if(_darkMode == QThemeType::DarkMode::Dark){
        return true;
    }else if(_darkMode == QThemeType::DarkMode::Light){
        return false;
    }else if(_darkMode == QThemeType::DarkMode::System){
        return _systemDark;
    }else{
        return false;
    }
}
