#include "timeboardmodel.h"

TimeboardModel::TimeboardModel(Downloader &d, DbManager &dbm, QObject *parent) :
    AbstractModel(parent), downloader(d), dbManager(dbm)
{
    m_ln.reserve(8);
    for (int i = 0; i < 8; i++) {m_ln.append(QVariant());}

    connect(&dbManager,
            SIGNAL(updateSavedStopFavouriteComplete(QString,bool)),
            this,
            SLOT(updateLn(QString)));
}

void TimeboardModel::updateLn(QString id) {
    m_ln = dbManager.getTimeboardBasicData(id);
    emit lnChanged();
}

void TimeboardModel::reload(QString id) {
    AbstractModel::startReload();
    this->updateLn(id);

    connect(&downloader,
            SIGNAL(timeboardSearchComplete(int,QNetworkReply*)),
            this,
            SLOT(reload_REPLY(int,QNetworkReply*)));

    downloader.getTimeboardSearch(id);
}

void TimeboardModel::reload_REPLY(int status, QNetworkReply* reply) {
    disconnect(&downloader,
               SIGNAL(timeboardSearchComplete(int,QNetworkReply*)),
               this,
               SLOT(reload_REPLY(int,QNetworkReply*)));

    if (status != 0) {
        AbstractModel::endReload();
        AbstractModel::setEmptyState("network_error");
        reply->deleteLater();
        return;
    }



    // Finish >>>
    AbstractModel::endReload();
    reply->deleteLater();
}
