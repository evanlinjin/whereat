#include "downloader.h"

Downloader::Downloader(QObject *parent) : QObject(parent)
{
    nm = new QNetworkAccessManager(this);

    connect(nm, SIGNAL(finished(QNetworkReply*)),
            this, SLOT(networkReplyHandler(QNetworkReply*)));
}

Downloader::~Downloader() {
    nm->deleteLater();
}

void Downloader::getStopsNearbySearch(double lat, double lon, double radius) {
    QNetworkRequest request;
    QString url = "https://api.at.govt.nz/v1/gtfs/stops/geosearch?"
            + "lat="      + QString::number(lat, 'f', 6)    + "&"
            + "lng="      + QString::number(lon, 'f', 6)    + "&"
            + "distance=" + QString::number(radius, 'f', 0) + "&"
            + "api_key="  + Keys::atApi;

    request.setUrl(QUrl(url));
}
