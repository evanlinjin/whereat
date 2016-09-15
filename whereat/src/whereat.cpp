#include "whereat.h"

WhereAt::WhereAt(QObject *parent) : QObject(parent) {

    locator = new Locator(this);
    downloader = new Downloader(this);
    settingsManager = new SettingsManager(this);
    jsonParser = new JsonParser(this);

    favouriteStopsModel = new StopModel(this);
    nearbyStopsModel = new StopModel(this);
    textSearchStopsModel = new StopModel(this);

    dbSavedStops = new DbSavedStops(this);
    dbStops = new DbStops(this);
}

WhereAt::~WhereAt() {

    locator->deleteLater();
    downloader->deleteLater();
    settingsManager->deleteLater();
    jsonParser->deleteLater();

    favouriteStopsModel->deleteLater();
    nearbyStopsModel->deleteLater();
    textSearchStopsModel->deleteLater();

    dbSavedStops->deleteLater();
    dbStops->deleteLater();
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
    emit progress(QString("Downloading..."), dlCount+1, dlMax);

    // Only Continue if all files downloaded.
    if (dlCount == dlMax) {
        disconnect(downloader, SIGNAL(getAllOneComplete(QNetworkReply*)),
                   this, SLOT(updateDbManual_REPLY(QNetworkReply*)));
        disconnect(downloader, SIGNAL(getAllOneFailed(QNetworkReply::NetworkError)),
                   this, SLOT(updateDbManual_REPLY(QNetworkReply::NetworkError)));

        if (dlFails > 0) { // If some downloads fail, stop all & reset.
            qDebug() << this << "updateDbManual_REPLY FAILED" << dlFails;
            parseCount = dlCount = dlFails = dlMax = 0;
            this->clearDlReplyList();
            downloader->resetConnections();
            return;
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
    emit progress0(parseCount, dlMax);

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

// DEFINITIONS FOR : UPDATING FAVOURITE STOPS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

void WhereAt::reloadFavouriteStops() {
    qDebug() << this << "reloadFavouriteStops";
    favouriteStopsModel->clear();
    favouriteStopsModel->setLoading(true);
    eventLoop.processEvents();

    QStringList idList = dbSavedStops->getFavouritesList();
    QList<AbstractItem> favList = dbStops->fillList(idList);
    qDebug() << "SIZE OF FAV LIST:" << favList.size();
    favouriteStopsModel->append(favList, idList);

    favouriteStopsModel->setLoading(false);
    eventLoop.processEvents();
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
    eventLoop.processEvents();

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

    QStringList favList = dbSavedStops->getFavouritesList();
    nearbyStopsModel->append(list, favList);
    nearbyStopsModel->setLoading(false);
}

// DEFINITIONS FOR : UPDATING TEXT SEARCH STOPS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

void WhereAt::reloadTextSearch(QString query) {
    qDebug() << this << "reloadTextSearch" << query;
    textSearchStopsModel->clear();
    textSearchStopsModel->setLoading(true);
    eventLoop.processEvents();

    // For disabling API calls with empty searches.
    if (query == "") {
        textSearchStopsModel->setLoading(false);
        eventLoop.processEvents();
        return;
    }

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

    QStringList favList = dbSavedStops->getFavouritesList();
    textSearchStopsModel->append(list, favList);
    textSearchStopsModel->setLoading(false);
}

// Hacked fix for a bug where loader for text search is enabled randomnly.
void  WhereAt::reloadTextSearch_forceLoadingOff() {
    textSearchStopsModel->setLoading(false);
}

// DEFINITIONS FOR : UPDATING SAVED STOPS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

void WhereAt::updateStopFavourite(QString id, bool fav) {
    qDebug() << this << "updateStopFavourite" << id << fav;
    connect(dbSavedStops, SIGNAL(updateFavouriteComplete(QString,bool)),
            favouriteStopsModel, SLOT(updateFavourite(QString,bool)));
    connect(dbSavedStops, SIGNAL(updateFavouriteComplete(QString,bool)),
            favouriteStopsModel, SLOT(removeRowWithId(QString,bool)));
    connect(dbSavedStops, SIGNAL(updateFavouriteComplete(QString,bool)),
            nearbyStopsModel, SLOT(updateFavourite(QString,bool)));
    connect(dbSavedStops, SIGNAL(updateFavouriteComplete(QString,bool)),
            textSearchStopsModel, SLOT(updateFavourite(QString,bool)));

    dbSavedStops->updateFavourite(id, fav);
}

// DEFINITIONS FOR : UPDATING STOP TIMEBOARD >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

void WhereAt::updateStopTimeboard(QString id) {
    qDebug() << this << "updateStopTimeboard" << id;
    connect(dbStops, SIGNAL(getStopDataComplete(QStringList,QList<double>)),
            this, SIGNAL(updateStopTimeboardComplete_StopData(QStringList,QList<double>)));
    connect(dbSavedStops, SIGNAL(getOneComplete(QString,bool,int,int,QString)),
            this, SIGNAL(updateStopTimeboardComplete_SavedStopData(QString,bool,int,int,QString)));

    dbStops->getStopData(id);
    dbSavedStops->getOne(id);
}





