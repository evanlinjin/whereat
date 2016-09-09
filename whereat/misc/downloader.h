#ifndef DOWNLOADER_H
#define DOWNLOADER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>

#include "keys.h"

class Downloader : public QObject
{
    Q_OBJECT

public:
    explicit Downloader(QObject *parent = 0);
    ~Downloader();

private:
    QNetworkAccessManager* nm;

signals:
    void stopsNearbySearchComplete(bool status, QNetworkReply* reply);
    void stopsTextSearchComplete(bool status, QNetworkReply* reply);
    void timeboardSearchComplete(bool status, QNetworkReply* reply);
    void timeboardRtSearchComplete(bool status, QNetworkReply* reply);

public slots:
    void getStopsNearbySearch(double lat, double lon, double radius);
    void getStopsTextSearch(QString query);
    void getTimeboardSearch(QString stop_id);
    void getTimeboardRtSearch(QStringList trip_ids);

private slots:
    void networkReplyHandler(QNetworkReply* reply);
};

#endif // DOWNLOADER_H
