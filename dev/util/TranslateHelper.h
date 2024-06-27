#ifndef TRANSLATEHELPER_H
#define TRANSLATEHELPER_H

#include <QObject>
#include <QtQml/qqml.h>
#include <QTranslator>
#include "dev/singleton.h"
#include "dev/stdafx.h"

class TranslateHelper : public QObject, public Singleton<TranslateHelper>
{
    Q_OBJECT
    Q_PROPERTY_AUTO(QString,current)
    Q_PROPERTY_READONLY_AUTO(QStringList,languages)

private:
    explicit TranslateHelper(QObject* parent = nullptr);
    friend class Singleton<TranslateHelper>; // permit singleton access into protected

public:
    ~TranslateHelper() override;
    void init(QQmlEngine* engine);

private:
    QQmlEngine* _engine = nullptr;
    QTranslator* _translator = nullptr;
};

#endif // TRANSLATEHELPER_H
