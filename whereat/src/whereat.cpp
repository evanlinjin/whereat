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

// PRIVATE DEFINITIONS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

void WhereAt::clearDlReplyList() {
    qDebug() << this << "clearDlReplyList" << dlReplyList.size();
    for (int i = 0; i < dlReplyList.size(); i++) {
        dlReplyList.takeAt(0)->deleteLater();
    }
}

// DEFINITIONS FOR : UPDATE DATABASE MANUAL >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

void WhereAt::updateDbManual() {
    qDebug() << this << "updateDbManual";
    parseCount = dlCount = dlFails = 0; dlMax = 6;
    this->clearDlReplyList();

    connect(downloader, SIGNAL(getAllOneComplete(QNetworkReply*)),
            this, SLOT(updateDbManual_REPLY(QNetworkReply*)));
    connect(downloader, SIGNAL(getAllOneFailed(QNetworkReply::NetworkError)),
            this, SLOT(updateDbManual_REPLY(QNetworkReply::NetworkError)));

    downloader->getAll();
}

void WhereAt::updateDbManual_REPLY(QNetworkReply *reply) {
    qDebug() << this << "updateDbManual_REPLY" << reply->url().path();
    dlCount += 1;
    this->dlReplyList.append(reply);

    // Only Continue if all files downloaded.
    if (dlCount == dlMax) {
        disconnect(downloader, SIGNAL(getAllOneComplete(QNetworkReply*)),
                   this, SLOT(updateDbManual_REPLY(QNetworkReply*)));
        disconnect(downloader, SIGNAL(getAllOneFailed(QNetworkReply::NetworkError)),
                   this, SLOT(updateDbManual_REPLY(QNetworkReply::NetworkError)));

        if (dlFails > 0) { // If some downloads fail, stop all & reset.
            parseCount = dlCount = dlFails = dlMax = 0;
            this->clearDlReplyList();
            downloader->resetConnections();
        }

        connect(jsonParser, SIGNAL(parseAllComplete_clearReplyList()),
                this, SLOT(clearDlReplyList()));
        connect(jsonParser, SIGNAL(parseAll_ONEComplete(QString)),
                this, SLOT(updateDbManual_JSON(QString)));
        connect(jsonParser, SIGNAL(parseAll_ONEProgress(QString,int,int)),
                this, SIGNAL(progress(QString,int,int)));

        jsonParser->parseAll(this->dlReplyList);
    }
}

void WhereAt::updateDbManual_REPLY(QNetworkReply::NetworkError error) {
    qDebug() << this << "updateDbManual_REPLY" << error;
    dlFails += 1;
}

void WhereAt::updateDbManual_JSON(QString name) {
    qDebug() << this << "updateDbManual_JSON DONE" << name;
    parseCount += 1;

    if (parseCount == dlMax) {
        disconnect(jsonParser, SIGNAL(parseAllComplete_clearReplyList()),
                this, SLOT(clearDlReplyList()));
        disconnect(jsonParser, SIGNAL(parseAll_ONEComplete(QString)),
                this, SLOT(updateDbManual_JSON(QString)));
        disconnect(jsonParser, SIGNAL(parseAll_ONEProgress(QString,int,int)),
                this, SIGNAL(progress(QString,int,int)));

        parseCount = dlCount = dlFails = dlMax = 0;
        downloader->resetConnections();
        emit updateDbManualComplete();
    }
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
