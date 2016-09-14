#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>
#include <QtQml>

#include "keys.h"
#include "src/whereat.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQuickView* view = new QQuickView();
    view->setResizeMode(QQuickView::SizeRootObjectToView);

    WhereAt* whereat = new WhereAt();

    QObject::connect(whereat, SIGNAL(quit()), &app, SLOT(quit()));

    view->engine()->rootContext()->setContextProperty("WhereAt", whereat);
    view->engine()->rootContext()->setContextProperty("Settings", whereat->settingsManager);

    view->engine()->rootContext()->setContextProperty("FavouriteStopsModel", whereat->favouriteStopsModel);
    view->engine()->rootContext()->setContextProperty("NearbyStopsModel", whereat->nearbyStopsModel);
    view->engine()->rootContext()->setContextProperty("TextSearchStopsModel", whereat->textSearchStopsModel);

    view->setSource(QUrl(QStringLiteral("qrc:///qml/Main.qml")));
    view->show();

    return app.exec();
}
