#include "whereat.h"

WhereAt::WhereAt(QObject *parent) : QObject(parent) {

    locator = new Locator(this);
    downloader = new Downloader(this);
    settingsManager = new SettingsManager(this);

    favouriteStopsModel = new StopModel(this);
    nearbyStopsModel = new StopModel(this);
    recentStopsModel = new StopModel(this);
    textSearchStopsModel = new StopModel(this);
}

WhereAt::~WhereAt() {

    locator->deleteLater();
    downloader->deleteLater();
    settingsManager->deleteLater();

    favouriteStopsModel->deleteLater();
    nearbyStopsModel->deleteLater();
    recentStopsModel->deleteLater();
    textSearchStopsModel->deleteLater();
}

void WhereAt::reloadNearbyStopsModel() {

    nearbyStopsModel->clear();
    nearbyStopsModel->setLoading(true);

    connect(locator, SIGNAL(response(bool,double,double)),
            this, SLOT(reloadNearbyStopsModel_COORD(bool,double,double)));

    locator->request();
}

void WhereAt::reloadNearbyStopsModel_COORD(bool status, double lat, double lon) {

    disconnect(locator, SIGNAL(response(bool,double,double)),
            this, SLOT(reloadNearbyStopsModel_COORD(bool,double,double)));

    if (status == false) {
        nearbyStopsModel->setLoading(false);
        nearbyStopsModel->setEmptyState("location_error");
        return;
    }

    connect(downloader, SIGNAL(stopsNearbySearchComplete(int,QNetworkReply*)),
            this, SLOT(reloadNearbyStopsModel_REPLY(int,QNetworkReply*)));

    downloader->getStopsNearbySearch(
                lat, lon, settingsManager->stopSearchRadius());
}

void WhereAt::reloadNearbyStopsModel_REPLY(int status, QNetworkReply* reply) {

    disconnect(downloader, SIGNAL(stopsNearbySearchComplete(int,QNetworkReply*)),
            this, SLOT(reloadNearbyStopsModel_REPLY(int,QNetworkReply*)));

    if (status != 0) {
        nearbyStopsModel->setLoading(false);
        nearbyStopsModel->setEmptyState("network_error");
        return;
    }

    qDebug() << "Everything Complete!";
}
