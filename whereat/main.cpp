#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>
#include <QtQml>

#include "keys.h"
#include "whereat.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQuickView* view = new QQuickView();
    view->setResizeMode(QQuickView::SizeRootObjectToView);

    WhereAt* whereat = new WhereAt();

    view->engine()->rootContext()->setContextProperty("WhereAt", whereat);
    view->engine()->rootContext()->setContextProperty("Settings", whereat->settingsManager);

    view->engine()->rootContext()->setContextProperty("FavouriteStopsModel", whereat->favouriteStopsModel);
    view->engine()->rootContext()->setContextProperty("NearbyStopsModel", whereat->nearbyStopsModel);
    view->engine()->rootContext()->setContextProperty("RecentStopsModel", whereat->recentStopsModel);

    view->setSource(QUrl(QStringLiteral("qrc:///Main.qml")));
    view->show();

    return app.exec();
}
