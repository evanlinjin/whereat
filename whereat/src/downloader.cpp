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

void Downloader::getAll() {
    disconnect(nm, SIGNAL(finished(QNetworkReply*)),
            this, SLOT(networkReplyHandler(QNetworkReply*)));
    connect(nm, SIGNAL(finished(QNetworkReply*)),
            this, SIGNAL(getAllOneComplete(QNetworkReply*)));

    QString start_url("https://api.at.govt.nz/v1/gtfs/");
    QString end_url("?api_key="); end_url.append(Keys::atApi);

    QStringList mid_url; mid_url.reserve(6);
    mid_url.append("versions");
    mid_url.append("agency");
    mid_url.append("routes");
    mid_url.append("calendar");
    mid_url.append("stops");
    mid_url.append("trips");

    for (int i = 0; i < mid_url.size(); i++) {
        QNetworkReply* reply = nm-> get(QNetworkRequest(
                    QUrl(start_url + mid_url.at(i) + end_url)));
        connect(reply, SIGNAL(error(QNetworkReply::NetworkError)),
                this, SIGNAL(getAllOneFailed(QNetworkReply::NetworkError)));
    }
}

void Downloader::resetConnections() {
    qDebug() << this << "resetConnections";
    connect(nm, SIGNAL(finished(QNetworkReply*)),
            this, SLOT(networkReplyHandler(QNetworkReply*)));
    disconnect(nm, SIGNAL(finished(QNetworkReply*)),
            this, SLOT(getAllOneComplete(QNetworkReply*)));
}

void Downloader::getStopsNearbySearch(double lat, double lon, double radius) {
    QString url("https://api.at.govt.nz/v1/gtfs/stops/geosearch?");
    url += "lat=";     url += QString::number(lat, 'f', 6);    url += "&";
    url += "lng=";     url += QString::number(lon, 'f', 6);    url += "&";
    url +="distance="; url += QString::number(radius, 'f', 0); url += "&";
    url += "api_key="; url += Keys::atApi;
    nm->get(QNetworkRequest(QUrl(url)));
    qDebug() << this << "REQUEST:" << url;
}

void Downloader::getStopsTextSearch(QString query) {
    QString url("https://api.at.govt.nz/v1/gtfs/stops/search/"
                + query + "?api_key=" + Keys::atApi);
    nm->get(QNetworkRequest(QUrl(url)));
    qDebug() << this << "REQUEST:" << url;
}

void Downloader::getTimeboardSearch(QString stop_id) {
    QString url("https://api.at.govt.nz/v1/gtfs/stopTimes/stopId/"
                + stop_id + "?api_key=" + Keys::atApi);
    nm->get(QNetworkRequest(QUrl(url)));
    qDebug() << this << "REQUEST:" << url;
}

void Downloader::getTimeboardRtSearch(QStringList trip_ids) {
    QString url("https://api.at.govt.nz/v1/public/realtime/tripupdates?tripid=");
    for (int i = 0; i < trip_ids.size(); i++) {
        url += trip_ids.at(i) + ",";
    }
    url.remove(url.size() - 1, 1);
    url += "&api_key=" + Keys::atApi;
    nm->get(QNetworkRequest(QUrl(url)));
    qDebug() << this << "REQUEST:" << url;
}

void Downloader::getRoutesNearbySearch(double lat, double lon, double radius) {
    QString url("https://api.at.govt.nz/v1/gtfs/routes/geosearch?");
    url += "lat=";      url += QString::number(lat, 'f', 6);    url += "&";
    url += "lng=";      url += QString::number(lon, 'f', 6);    url += "&";
    url += "distance="; url += QString::number(radius, 'f', 0); url += "&";
    url += "api_key=";  url += Keys::atApi;
    nm->get(QNetworkRequest(QUrl(url)));
    qDebug() << this << "REQUEST:" << url;
}

void Downloader::networkReplyHandler(QNetworkReply* reply) {
    QString path = reply->url().path();
    if (path.contains("/v1/gtfs/stops/geosearch")) {
        emit stopsNearbySearchComplete(reply->error(), reply);
    }
    else if (path.contains("/v1/gtfs/stops/search")) {
        emit stopsTextSearchComplete(reply->error(), reply);
    }
    else if (path.contains("/v1/gtfs/stopTimes/stopId")) {
        emit timeboardSearchComplete(reply->error(), reply);
    }
    else if (path.contains("/v1/public/realtime/tripupdates")) {
        emit timeboardRtSearchComplete(reply->error(), reply);
    }
    else if (path.contains("/v1/gtfs/routes/geosearch")) {
        emit routesNearbySearchComplete(reply->error(), reply);
    }
    else {
        qDebug() << this << "networkReplyHandler" << "Unknown" << reply->url();
    }
}
