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

    view->engine()->rootContext()->setContextProperty("whereat", whereat);
    view->engine()->rootContext()->setContextProperty("locator", whereat->locator);
    view->engine()->rootContext()->setContextProperty("walistmodel", whereat->listModel);
    view->engine()->rootContext()->setContextProperty("favouritesModel", whereat->favouritesModel);

    //whereat->setAtApiKey(Keys::atApi);

    view->setSource(QUrl(QStringLiteral("qrc:///Main.qml")));
    view->show();

    return app.exec();
}
