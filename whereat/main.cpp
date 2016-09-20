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
    QGuiApplication app(argc, argv);

    qmlRegisterType<WhereAt>("WhereAt", 1, 0, "WhereAt");

    // OBJECTS >>>

    Locator* locator = new Locator();
    Downloader* downloader = new Downloader(); // needed by WhereAt...
    SettingsManager* settingsManager = new SettingsManager();
    DbManager* dbManager = new DbManager();

    FavouriteStopsModel* favouriteStopsModel = new FavouriteStopsModel(*dbManager);
    NearbyStopsModel* nearbyStopsModel = new NearbyStopsModel(*locator, *downloader, *dbManager, *settingsManager);
    SearchStopsModel* textSearchStopsModel = new SearchStopsModel(*downloader, *dbManager);
    TimeboardModel* timeboardModel = new TimeboardModel(*downloader, *dbManager);


    // EXPOSING TO QML >>>

    QQuickView* view = new QQuickView();
    view->setResizeMode(QQuickView::SizeRootObjectToView);

    view->engine()->rootContext()->setContextProperty("Settings", settingsManager);
    view->engine()->rootContext()->setContextProperty("DbManager", dbManager);

    view->engine()->rootContext()->setContextProperty("FavouriteStopsModel", favouriteStopsModel);
    view->engine()->rootContext()->setContextProperty("NearbyStopsModel", nearbyStopsModel);
    view->engine()->rootContext()->setContextProperty("TextSearchStopsModel", textSearchStopsModel);
    view->engine()->rootContext()->setContextProperty("TimeboardModel", timeboardModel);

    view->setSource(QUrl(QStringLiteral("qrc:///qml/Main.qml")));
    view->show();

    return app.exec();
}
