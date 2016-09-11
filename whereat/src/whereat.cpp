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

// DEFINITIONS FOR : UPDATING NEARBY STOPS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

void WhereAt::updateNearbyStops() {
    if (nearbyStopsModel->count() == 0) {
        this->reloadNearbyStops();
    }
}

void WhereAt::reloadNearbyStops() {
    qDebug() << this << "reloadNearbyStops";
    nearbyStopsModel->clear();
    nearbyStopsModel->setLoading(true);

    connect(locator, SIGNAL(response(bool,double,double)),
            this, SLOT(reloadNearbyStops_COORD(bool,double,double)));

    locator->request();
}

void WhereAt::reloadNearbyStops_COORD(bool status, double lat, double lon) {
    qDebug() << this << "reloadNearbyStops_COORD" << status << lat << lon;
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
    qDebug() << this << "reloadNearbyStops_REPLY" << status << reply->error();
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
    qDebug() << this << "reloadNearbyStops_JSON" << list.size();
    disconnect(jsonParser, SIGNAL(parseNearbyStopsComplete(QList<AbstractItem>)),
            this, SLOT(reloadNearbyStops_JSON(QList<AbstractItem>)));

    nearbyStopsModel->append(list);
    nearbyStopsModel->setLoading(false);
}

// DEFINITIONS FOR : UPDATING TEXT SEARCH STOPS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

void WhereAt::reloadTextSearch(QString query) {
    qDebug() << this << "reloadTextSearch" << query;
    textSearchStopsModel->clear();
    textSearchStopsModel->setLoading(true);

    connect(downloader, SIGNAL(stopsTextSearchComplete(int,QNetworkReply*)),
            this, SLOT(reloadTextSearch_REPLY(int,QNetworkReply*)));

    downloader->getStopsTextSearch(query);
}

void WhereAt::reloadTextSearch_REPLY(int status, QNetworkReply* reply) {
    qDebug() << this << "reloadTextSearch_REPLY" << status << reply->error();
    disconnect(downloader, SIGNAL(stopsTextSearchComplete(int,QNetworkReply*)),
               this, SLOT(reloadTextSearch_REPLY(int,QNetworkReply*)));

    if (status != 0) {
        textSearchStopsModel->setLoading(false);
        textSearchStopsModel->setEmptyState("network_error");
        reply->deleteLater();
        return;
    }

    connect(jsonParser, SIGNAL(parseTextSearchStopsComplete(QList<AbstractItem>)),
            this, SLOT(reloadTextSearch_JSON(QList<AbstractItem>)));

    jsonParser->parseTextSearchStops(reply);
}

void WhereAt::reloadTextSearch_JSON(QList<AbstractItem> list) {
    qDebug() << this << "reloadTextSearch_JSON" << list.size();
    disconnect(jsonParser, SIGNAL(parseTextSearchStopsComplete(QList<AbstractItem>)),
               this, SLOT(reloadTextSearch_JSON(QList<AbstractItem>)));

    textSearchStopsModel->append(list);
    textSearchStopsModel->setLoading(false);
}
