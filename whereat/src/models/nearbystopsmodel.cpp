#include "nearbystopsmodel.h"

NearbyStopsModel::NearbyStopsModel(Locator &l, Downloader &d, DbManager &dbm, SettingsManager &s, QObject *parent) :
    AbstractModel(parent), locator(l), downloader(d), dbManager(dbm), settingsManager(s)
{
    connect(&dbManager,
            SIGNAL(updateSavedStopFavouriteComplete(QString,bool)),
            this,
            SLOT(updateFavourite(QString,bool)));
}

NearbyStopsModel::~NearbyStopsModel() {

}

void NearbyStopsModel::update() {
    if (AbstractModel::count() == 0) {
        this->reload();
    } else {
        AbstractModel::endReload();
    }
}

void NearbyStopsModel::reload() {
    AbstractModel::startReload();

    connect(&locator, SIGNAL(response(bool,double,double)),
            this, SLOT(reload_COORD(bool,double,double)));

    locator.request();
}

void NearbyStopsModel::reload_COORD(bool status, double lat, double lon) {
    disconnect(&locator, SIGNAL(response(bool,double,double)),
               this, SLOT(reload_COORD(bool,double,double)));

    if (status == false) {
        AbstractModel::endReload();
        AbstractModel::setEmptyState("location_error");
        return;
    }
    connect(&downloader, SIGNAL(stopsNearbySearchComplete(int,QNetworkReply*)),
            this, SLOT(reload_REPLY(int,QNetworkReply*)));

    downloader.getStopsNearbySearch(lat, lon, 2000);
}

void NearbyStopsModel::reload_REPLY(int status, QNetworkReply* reply) {
    disconnect(&downloader, SIGNAL(stopsNearbySearchComplete(int,QNetworkReply*)),
               this, SLOT(reload_REPLY(int,QNetworkReply*)));

    if (status != 0) {
        AbstractModel::endReload();
        AbstractModel::setEmptyState("network_error");
        reply->deleteLater();
        return;
    }

    // PARSE REPLY >>>
    QJsonArray response = AbstractModel::takeResponseArray(reply);
    QList<AbstractItem> list;
    list.reserve(response.size());

    for (int i = 0; i < response.size(); i++) {
        QJsonObject obj = response.at(i).toObject();
        AbstractItem item = getEmptyItem();

        item.id = obj["stop_id"].toString();
        if (item.id.size() >= 5) {continue;} // Get rid of parent stations.
        item.ln0 = obj["stop_code"].toString();
        item.ln1 = obj["stop_name"].toString();
        item.ln2 = QString::number(obj["st_distance_sphere"].toDouble(), 'f', 0)
                + QString("m");
        item.type = this->getIconUrl(item.ln1);
        list.append(item);
    }
    AbstractModel::append(list);
    AbstractModel::eventLoop.processEvents();

    // Get favourites information >>>
    QList<SavedStopItem> favList = dbManager.getStopFavouritesList();
    for (int i = 0; i < favList.size(); i++) {
        QModelIndex index = AbstractModel::getIndex(favList.at(i).id);
        AbstractModel::setData(index, favList.at(i).fav, AbstractModel::favRole);
        AbstractModel::setData(index, favList.at(i).color, AbstractModel::colorRole);
    }

    AbstractModel::endReload();
}
