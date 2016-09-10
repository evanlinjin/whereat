#include "whereat.h"

WhereAt::WhereAt(QObject *parent) : QObject(parent) {

    locator = new Locator(this);
    downloader = new Downloader(this);
    settingsManager = new SettingsManager(this);

    favouriteStopsModel = new StopModel(this);
    nearbyStopsModel = new StopModel(this);
    recentStopsModel = new StopModel(this);
    textSearchStopsModel = new StopModel(this);

    jsonParser = new JsonParser(this);
}

WhereAt::~WhereAt() {

    locator->deleteLater();
    downloader->deleteLater();
    settingsManager->deleteLater();

    favouriteStopsModel->deleteLater();
    nearbyStopsModel->deleteLater();
    recentStopsModel->deleteLater();
    textSearchStopsModel->deleteLater();

    jsonParser->deleteLater();
}

void WhereAt::reloadNearbyStops() {

    nearbyStopsModel->clear();
    nearbyStopsModel->setLoading(true);

    connect(locator, SIGNAL(response(bool,double,double)),
            this, SLOT(reloadNearbyStops_COORD(bool,double,double)));

    locator->request();
}

void WhereAt::reloadNearbyStops_COORD(bool status, double lat, double lon) {

    disconnect(locator, SIGNAL(response(bool,double,double)),
               this, SLOT(reloadNearbyStops_COORD(bool,double,double)));

    if (status == false) {
        nearbyStopsModel->setLoading(false);
        nearbyStopsModel->setEmptyState("location_error");
        return;
    }

    connect(downloader, SIGNAL(stopsNearbySearchComplete(int,QNetworkReply*)),
            this, SLOT(reloadNearbyStops_REPLY(int,QNetworkReply*)));

    downloader->getStopsNearbySearch(
                lat, lon, settingsManager->stopSearchRadius());
}

void WhereAt::reloadNearbyStops_REPLY(int status, QNetworkReply* reply) {

    disconnect(downloader, SIGNAL(stopsNearbySearchComplete(int,QNetworkReply*)),
               this, SLOT(reloadNearbyStops_REPLY(int,QNetworkReply*)));

    if (status != 0) {
        nearbyStopsModel->setLoading(false);
        nearbyStopsModel->setEmptyState("network_error");
        reply->deleteLater();
        return;
    }

    connect(jsonParser, SIGNAL(parseNearbyStopsComplete(QList<AbstractItem>)),
            this, SLOT(reloadNearbyStops_JSON(QList<AbstractItem>)));

    jsonParser->parseNearbyStops(reply);
}

void WhereAt::reloadNearbyStops_JSON(QList<AbstractItem> list) {

    disconnect(jsonParser, SIGNAL(parseNearbyStopsComplete(QList<AbstractItem>)),
            this, SLOT(reloadNearbyStops_JSON(QList<AbstractItem>)));

    nearbyStopsModel->append(list);
    nearbyStopsModel->setLoading(false);
}
