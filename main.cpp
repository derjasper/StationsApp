//#include <QGuiApplication>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSettings>
#include <QQuickStyle>

#include "fslistmodel.h"
#include "launcher.h"
#include "androidpermissions.h"

int main(int argc, char *argv[])
{
    // QGuiApplication
    QApplication::setApplicationName("stations-app");
    QApplication::setOrganizationName("de.jaspernalbach");
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    qmlRegisterType<FsListModel>("stationsapp", 1, 0, "FsListModel");
    qmlRegisterType<Launcher>("stationsapp", 1, 0, "Launcher");
    qmlRegisterType<AndroidPermissions>("stationsapp", 1, 0, "AndroidPermissions");

    QApplication app(argc, argv);

    QSettings settings;
    QQuickStyle::setStyle(settings.value("style", "Default").toString());

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("availableStyles", QQuickStyle::availableStyles());
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
