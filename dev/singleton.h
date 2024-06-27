#ifndef SINGLETON_H
#define SINGLETON_H

/* single instance with global acceess */

template <typename T>
class Singleton {
public:
    static T& getInstance() {
        static T instance; // static instance
        return instance; // same object
    }

protected:
    // prevent direct instantiation
    Singleton() {}
    virtual ~Singleton() {}

private:
    // explicitly delete to disallow copying or assigning
    Singleton(const Singleton&) = delete;
    Singleton& operator=(const Singleton&) = delete;
};

#endif // SINGLETON_H
