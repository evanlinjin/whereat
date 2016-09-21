#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQuick/QQuickView>
#include <QQuickView>
#include <QtQml>

#include "keys.h"
#include "src/whereat.h"

#include "src/db/dbmanager.h"
#include "src/models/abstractmodel.h"
#include "src/models/timeboardmodel.h"
#include "src/models/favouritestopsmodel.h"
#include "src/models/nearbystopsmodel.h"
#include "src/models/searchstopsmodel.h"
#include "src/locator.h"
#include "src/downloader.h"
#include "src/settingsmanager.h"
#include "src/jsonparser.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    qmlRegisterType<WhereAt>("WhereAt", 1, 0, "WhereAt");

    Locator* locator = new Locator();
    Downloader* downloader = new Downloader(); // needed by WhereAt...
    SettingsManager* settingsManager = new SettingsManager();
    DbManager* dbManager = new DbManager();

    FavouriteStopsModel* favouriteStopsModel = new FavouriteStopsModel(*dbManager);
    NearbyStopsModel* nearbyStopsModel = new NearbyStopsModel(*locator, *downloader, *dbManager, *settingsManager);
    SearchStopsModel* textSearchStopsModel = new SearchStopsModel(*downloader, *dbManager);
    TimeboardModel* timeboardModel = new TimeboardModel(*downloader, *dbManager);

    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("Settings", settingsManager);
    engine.rootContext()->setContextProperty("DbManager", dbManager);

    engine.rootContext()->setContextProperty("FavouriteStopsModel", favouriteStopsModel);
    engine.rootContext()->setContextProperty("NearbyStopsModel", nearbyStopsModel);
    engine.rootContext()->setContextProperty("TextSearchStopsModel", textSearchStopsModel);
    engine.rootContext()->setContextProperty("TimeboardModel", timeboardModel);

    engine.load(QUrl(QLatin1String("qrc:/android/main.qml")));

    return app.exec();
}
