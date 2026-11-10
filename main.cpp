#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include<QQmlContext>
#include "jsonkaydedici.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    JSonKaydedici kaydedici;
     engine.rootContext()->setContextProperty("kaydedici", &kaydedici);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("JSonRehber", "Main");

    return QGuiApplication::exec();
}
