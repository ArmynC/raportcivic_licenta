#ifndef COMPONENT_H
#define COMPONENT_H

#include <QObject>
#include <QQmlEngine>
#include "singleton.h"

class Component : public QObject
{
    Q_OBJECT
public:
    SINGLETON(Component)
    Q_DECL_EXPORT void registerTypes(QQmlEngine *engine);
    void registerTypes(const char *uri);
    void initializeEngine(QQmlEngine *engine, const char *uri);
private:
    const int major = 1;
    const int minor = 0;
    const char *uri = "Component";
};

#endif // COMPONENT_H
