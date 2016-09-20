#include "searchstopsmodel.h"

SearchStopsModel::SearchStopsModel(Downloader &d, DbManager &dbm, QObject *parent) :
    AbstractModel(parent), downloader(d), dbManager(dbm)
{
    connect(&dbManager,
            SIGNAL(updateSavedStopFavouriteComplete(QString,bool)),
            this,
            SLOT(updateFavourite(QString,bool)));
}

SearchStopsModel::~SearchStopsModel() {

}

void SearchStopsModel::reload(QString query) {
    AbstractModel::startReload();
    if (query == "") {
        AbstractModel::endReload();
        return;
    }

    connect(&downloader, SIGNAL(stopsTextSearchComplete(int,QNetworkReply*)),
            this, SLOT(reload_REPLY(int,QNetworkReply*)));

    downloader.getStopsTextSearch(query);
}

void SearchStopsModel::reload_REPLY(int status, QNetworkReply* reply) {
    disconnect(&downloader, SIGNAL(stopsTextSearchComplete(int,QNetworkReply*)),
               this, SLOT(reload_REPLY(int,QNetworkReply*)));

    if (status != 0) {
        AbstractModel::endReload();
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
